{
  AuditQuests.pas  -  Radiant Quest Marker

  Read-only discovery pass. Modifies nothing.

  Walks every QUST record in the loaded plugins, evaluates the record-level
  signals defined in Database/radiant_rules.json, and writes three files:

    output\audit_report.txt   human readable, one line per record
    output\quests.candidate.tsv  machine readable, ready to merge into quests.tsv
    output\unknown.tsv        named quests that carried radiant signals but are
                              not in the shipped database

  Run this BEFORE GenerateQuestMarkers.pas. It is the only thing allowed to
  promote a database entry to confidence 'verified'.

  Requirements
    - FO4Edit 4.1.5f or newer
    - Reference info must be built (it is by default). Without it the
      SMQN signal silently reports 0 and everything drops to 'likely'.

  Usage
    Load FO4Edit with Fallout4.esm, all DLC and any cc*.esl you want covered.
    Right click any plugin -> Apply Script -> AuditQuests.
}
unit UserScript;

const
  DB_SUBDIR      = 'RadiantQuestMarker\';
  MIN_SIGNALS    = 2;

var
  slReport, slCandidates, slUnknown, slPatterns, slDb, slSeen: TStringList;
  outDir: string;
  cntTotal, cntNamed, cntCandidate, cntExcluded, cntVerified: integer;

// ---------------------------------------------------------------- helpers

function EnsureDir(const p: string): string;
begin
  if not DirectoryExists(p) then
    ForceDirectories(p);
  Result := p;
end;

function SafeEditValue(e: IInterface; const path: string): string;
begin
  Result := '';
  try
    Result := GetElementEditValues(e, path);
  except
    Result := '';
  end;
end;

function ContainsCI(const haystack, needle: string): boolean;
begin
  Result := Pos(LowerCase(needle), LowerCase(haystack)) > 0;
end;

function StartsCI(const s, prefix: string): boolean;
begin
  Result := Pos(LowerCase(prefix), LowerCase(s)) = 1;
end;

function TabJoin(const s1, s2, s3: string): string;
begin
  Result := s1 + #9 + s2 + #9 + s3;
end;

function BoolToStr(b: boolean; dummy: boolean): string;
begin
  if b then Result := 'true' else Result := 'false';
end;

// EditorID pattern table, mirrored from radiant_rules.json.
// Format: pattern|mode|tag|faction|module
procedure LoadPatterns;
begin
  slPatterns := TStringList.Create;
  slPatterns.Add('RadiantOwned|prefix|settlement_defense|Minutemen|Settlement');
  slPatterns.Add('RadiantUnowned|prefix|minutemen_radiant|Minutemen|Settlement');
  slPatterns.Add('RadiantMinuteman|prefix|minutemen_radiant|Minutemen|Settlement');
  slPatterns.Add('MinRecruit|prefix|settlement_establishment|Minutemen|Settlement');
  slPatterns.Add('BoSR|prefix|brotherhood_radiant|Brotherhood of Steel|Vanilla');
  slPatterns.Add('RRR|prefix|railroad_radiant|Railroad|Vanilla');
  slPatterns.Add('InstR|prefix|institute_radiant|Institute|Vanilla');
  slPatterns.Add('DLC01Radiant|prefix|automatron_radiant|Other|Automatron');
  slPatterns.Add('DLC03Radiant|prefix|farharbor_radiant|Far Harbor|FarHarbor');
  slPatterns.Add('DLC04Radiant|prefix|nukaworld_radiant|Nuka-World|NukaWorld');
  slPatterns.Add('DLC04Raid|prefix|nukaworld_radiant|Nuka-World|NukaWorld');
  slPatterns.Add('Radiant|contains|radiant|Other|');
end;

function MatchPattern(const edid: string; var tag, faction, modul: string): boolean;
var
  i: integer;
  parts: TStringList;
begin
  Result := False;
  tag := ''; faction := ''; modul := '';
  parts := TStringList.Create;
  try
    parts.Delimiter := '|';
    parts.StrictDelimiter := True;
    for i := 0 to Pred(slPatterns.Count) do begin
      parts.DelimitedText := slPatterns[i];
      if parts.Count < 5 then Continue;
      if ((parts[1] = 'prefix') and StartsCI(edid, parts[0]))
      or ((parts[1] = 'contains') and ContainsCI(edid, parts[0])) then begin
        tag := parts[2]; faction := parts[3]; modul := parts[4];
        Result := True;
        Exit;
      end;
    end;
  finally
    parts.Free;
  end;
end;

function IsHardExcluded(const edid: string): boolean;
begin
  Result := StartsCI(edid, 'Dialogue') or
            StartsCI(edid, 'Player') or
            StartsCI(edid, 'Sys') or
            StartsCI(edid, 'Debug') or
            StartsCI(edid, 'WorkshopParent') or
            StartsCI(edid, 'MQ') or
            StartsCI(edid, 'COMPanion') or
            StartsCI(edid, 'AutoLoad') or
            StartsCI(edid, 'TutorialQuest') or
            ContainsCI(edid, 'Controller') or
            ContainsCI(edid, 'Manager') or
            ContainsCI(edid, 'Handler') or
            ContainsCI(edid, 'Holder') or
            ContainsCI(edid, 'Template') or
            ContainsCI(edid, 'Test');
end;

// Counts Story Manager Quest Nodes that point at this quest.
function SMQNRefCount(rec: IInterface): integer;
var
  i: integer;
  r: IInterface;
begin
  Result := 0;
  try
    for i := 0 to Pred(ReferencedByCount(rec)) do begin
      r := ReferencedByIndex(rec, i);
      if Signature(r) = 'SMQN' then Inc(Result);
    end;
  except
    Result := -1;   // reference info unavailable
  end;
end;

function AliasSignals(rec: IInterface; var settlementish: boolean): integer;
var
  aliases, al: IInterface;
  i: integer;
  nm: string;
begin
  Result := 0;
  settlementish := False;
  aliases := ElementByName(rec, 'Quest Aliases');
  if not Assigned(aliases) then Exit;
  for i := 0 to Pred(ElementCount(aliases)) do begin
    al := ElementByIndex(aliases, i);
    nm := SafeEditValue(al, 'ALID');
    if ContainsCI(nm, 'Workshop') or ContainsCI(nm, 'Settlement') or ContainsCI(nm, 'Settler') then
      settlementish := True;
    if ContainsCI(nm, 'Target') or ContainsCI(nm, 'Location') or ContainsCI(nm, 'Dungeon') then
      Result := 1;
  end;
end;

function TimerSignal(rec: IInterface): boolean;
var
  props, p, scripts, s: IInterface;
  i, j: integer;
  nm: string;
begin
  Result := False;
  scripts := ElementByPath(rec, 'VMAD\Scripts');
  if not Assigned(scripts) then Exit;
  for i := 0 to Pred(ElementCount(scripts)) do begin
    s := ElementByIndex(scripts, i);
    nm := SafeEditValue(s, 'scriptName');
    if ContainsCI(nm, 'Timer') or ContainsCI(nm, 'TimeLimit') then begin
      Result := True; Exit;
    end;
    props := ElementByName(s, 'Properties');
    if not Assigned(props) then Continue;
    for j := 0 to Pred(ElementCount(props)) do begin
      p  := ElementByIndex(props, j);
      nm := SafeEditValue(p, 'propertyName');
      if ContainsCI(nm, 'Timer') or ContainsCI(nm, 'TimeLimit')
      or ContainsCI(nm, 'DaysTo') or ContainsCI(nm, 'DaysUntil')
      or ContainsCI(nm, 'FailTime') then begin
        Result := True; Exit;
      end;
    end;
  end;
end;

function ModuleForSource(const src: string; timed, settlementish: boolean): string;
begin
  if StartsCI(src, 'cc') then                     Result := 'NextGen'
  else if src = 'DLCRobot.esm' then               Result := 'Automatron'
  else if src = 'DLCCoast.esm' then               Result := 'FarHarbor'
  else if src = 'DLCNukaWorld.esm' then           Result := 'NukaWorld'
  else if src = 'DLCworkshop03.esm' then          Result := 'VaultTec'
  else if (src = 'DLCworkshop01.esm')
       or (src = 'DLCworkshop02.esm') then        Result := 'OtherDLC'
  else if src = 'Fallout4.esm' then begin
    if timed then                                 Result := 'Timed'
    else if settlementish then                    Result := 'Settlement'
    else                                          Result := 'Vanilla';
  end
  else                                            Result := '';
end;

// Loads quests.tsv if present so the audit can report which shipped entries
// were confirmed. Key is lowercased name; value is the raw row.
procedure LoadShippedDb;
var
  path: string;
  i: integer;
  row: TStringList;
begin
  slDb := TStringList.Create;
  path := ScriptsPath + DB_SUBDIR + 'quests.tsv';
  if not FileExists(path) then begin
    AddMessage('  note: ' + path + ' not found - audit will run in pure discovery mode.');
    Exit;
  end;
  row := TStringList.Create;
  try
    row.LoadFromFile(path);
    for i := 0 to Pred(row.Count) do begin
      if (row[i] = '') or (Copy(row[i], 1, 1) = '#') then Continue;
      slDb.Add(row[i]);
    end;
  finally
    row.Free;
  end;
  AddMessage('  loaded ' + IntToStr(slDb.Count) + ' shipped database rows.');
end;

function ShippedRowForName(const nm: string): string;
var
  i: integer;
  f: TStringList;
begin
  Result := '';
  f := TStringList.Create;
  try
    f.Delimiter := '|';
    f.StrictDelimiter := True;
    for i := 0 to Pred(slDb.Count) do begin
      f.DelimitedText := slDb[i];
      if (f.Count > 2) and (LowerCase(Trim(f[2])) = LowerCase(Trim(nm))) then begin
        Result := slDb[i];
        Exit;
      end;
    end;
  finally
    f.Free;
  end;
end;

// ---------------------------------------------------------------- main

function Initialize: integer;
var
  fi, gi: integer;
  f, grp, rec, master: IInterface;
  edid, full, flags, src, tag, faction, modul, conf, sigList: string;
  smqn, score, aliasSig: integer;
  timed, settlementish, runOnce, hasName: boolean;
begin
  Result := 0;
  cntTotal := 0; cntNamed := 0; cntCandidate := 0; cntExcluded := 0; cntVerified := 0;

  outDir := EnsureDir(ScriptsPath + DB_SUBDIR + 'output\');
  LoadPatterns;
  LoadShippedDb;

  slReport     := TStringList.Create;
  slCandidates := TStringList.Create;
  slUnknown    := TStringList.Create;
  slSeen       := TStringList.Create;
  slSeen.Sorted := True;
  slSeen.Duplicates := dupIgnore;

  slReport.Add('=== Radiant Quest Marker :: Quest Audit ===');
  slReport.Add('xEdit: FO4Edit');
  slReport.Add('');
  slReport.Add('STATUS  SIGNALS  SOURCE | FORMID | EDITORID | NAME');
  slReport.Add('------------------------------------------------------------------');

  slCandidates.Add('# formID|editorID|originalName|tag|category|faction|dlc|repeatable|timed|settlementRelated|sourcePlugin|module|confidence|evidence');

  for fi := 0 to Pred(FileCount) do begin
    f := FileByIndex(fi);
    src := GetFileName(f);

    // never audit our own output
    if StartsCI(src, 'QuestMarkers_') then Continue;

    grp := GroupBySignature(f, 'QUST');
    if not Assigned(grp) then Continue;

    for gi := 0 to Pred(ElementCount(grp)) do begin
      rec := ElementByIndex(grp, gi);
      if Signature(rec) <> 'QUST' then Continue;

      // only look at each quest once, at its defining plugin
      master := MasterOrSelf(rec);
      if not Equals(master, rec) then Continue;

      Inc(cntTotal);

      edid := EditorID(rec);
      full := SafeEditValue(rec, 'FULL');
      hasName := Trim(full) <> '';

      if not hasName then begin
        Inc(cntExcluded);
        Continue;   // controllers and dialogue quests never reach the log
      end;
      Inc(cntNamed);

      if IsHardExcluded(edid) then begin
        Inc(cntExcluded);
        slReport.Add(TabJoin('EXCLUDE', '-', src + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' + edid + ' | ' + full));
        Continue;
      end;

      flags   := SafeEditValue(rec, 'DNAM\Flags');
      runOnce := ContainsCI(flags, 'Run Once');

      if runOnce then begin
        Inc(cntExcluded);
        slReport.Add(TabJoin('EXCLUDE', 'RunOnce', src + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' + edid + ' | ' + full));
        Continue;
      end;

      smqn     := SMQNRefCount(rec);
      aliasSig := AliasSignals(rec, settlementish);
      timed    := TimerSignal(rec);

      score   := 0;
      sigList := '';
      if smqn > 0 then begin score := score + 3; sigList := sigList + 'SMQN(' + IntToStr(smqn) + ') '; end;
      if not runOnce then begin score := score + 1; sigList := sigList + 'NotRunOnce '; end;
      if ContainsCI(flags, 'Allow repeated stages') then begin score := score + 2; sigList := sigList + 'RepeatStages '; end;
      if ContainsCI(flags, 'Repeats conditions')    then begin score := score + 2; sigList := sigList + 'RepeatCond '; end;
      if aliasSig > 0 then sigList := sigList + 'RotatingAlias ';
      if MatchPattern(edid, tag, faction, modul) then begin
        score := score + 2;
        sigList := sigList + 'EdidPattern ';
      end else begin
        tag := ''; faction := 'Other'; modul := '';
      end;
      if timed then sigList := sigList + 'Timer ';
      if settlementish then sigList := sigList + 'Settlement ';

      if score < MIN_SIGNALS + 1 then begin
        // 1 point is just NotRunOnce, which every non-run-once quest has
        Inc(cntExcluded);
        slReport.Add(TabJoin('SKIP', IntToStr(score), src + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' + edid + ' | ' + full));
        Continue;
      end;

      if modul = '' then
        modul := ModuleForSource(src, timed, settlementish);
      if timed and (modul = 'Vanilla') then modul := 'Timed';
      if tag = '' then tag := 'radiant';
      if timed and (tag = 'radiant') then tag := 'timed_radiant';

      // Confidence: only a Story Manager reference plus a naming-family match
      // is strong enough to call verified. Everything else stays 'likely'.
      if (smqn > 0) and ContainsCI(sigList, 'EdidPattern') then begin
        conf := 'verified';
        Inc(cntVerified);
      end else
        conf := 'likely';

      Inc(cntCandidate);
      slReport.Add(TabJoin(UpperCase(conf), IntToStr(score), src + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' + edid + ' | ' + full));
      slReport.Add('         signals: ' + Trim(sigList) + ' | flags: ' + flags);

      slCandidates.Add(
        IntToHex(FixedFormID(rec), 8) + '|' +
        edid + '|' +
        full + '|' +
        tag + '|' +
        'Radiant' + '|' +
        faction + '|' +
        src + '|' +
        'true' + '|' +
        BoolToStr(timed, True) + '|' +
        BoolToStr(settlementish, True) + '|' +
        src + '|' +
        modul + '|' +
        conf + '|' +
        Trim(sigList));

      if ShippedRowForName(full) = '' then
        slUnknown.Add(IntToHex(FixedFormID(rec), 8) + '|' + edid + '|' + full + '|' + src + '|' + Trim(sigList));
    end;
  end;

  slReport.Add('');
  slReport.Add('=== Summary ===');
  slReport.Add('QUST records scanned : ' + IntToStr(cntTotal));
  slReport.Add('  with a display name: ' + IntToStr(cntNamed));
  slReport.Add('Candidates            : ' + IntToStr(cntCandidate));
  slReport.Add('  of which verified   : ' + IntToStr(cntVerified));
  slReport.Add('Excluded / skipped    : ' + IntToStr(cntExcluded));
  slReport.Add('Not in shipped DB     : ' + IntToStr(slUnknown.Count));
  if SMQNRefCount(nil) = -1 then
    slReport.Add('WARNING: reference info unavailable - SMQN signal was not evaluated.');

  slReport.SaveToFile(outDir + 'audit_report.txt');
  slCandidates.SaveToFile(outDir + 'quests.candidate.tsv');
  slUnknown.SaveToFile(outDir + 'unknown.tsv');

  AddMessage('');
  AddMessage('=== Quest Audit complete ===');
  AddMessage('Scanned ' + IntToStr(cntTotal) + ' QUST records, ' + IntToStr(cntCandidate) + ' candidates, ' + IntToStr(cntVerified) + ' verified.');
  AddMessage('Wrote: ' + outDir + 'audit_report.txt');
  AddMessage('Wrote: ' + outDir + 'quests.candidate.tsv');
  AddMessage('Wrote: ' + outDir + 'unknown.tsv');
  AddMessage('Review the candidate file, then merge into quests.tsv before generating.');
end;

function Process(e: IInterface): integer;
begin
  Result := 0;   // all work happens in Initialize
end;

function Finalize: integer;
begin
  if Assigned(slReport)     then slReport.Free;
  if Assigned(slCandidates) then slCandidates.Free;
  if Assigned(slUnknown)    then slUnknown.Free;
  if Assigned(slPatterns)   then slPatterns.Free;
  if Assigned(slDb)         then slDb.Free;
  if Assigned(slSeen)       then slSeen.Free;
  Result := 0;
end;

end.
