{
  GenerateQuestMarkers.pas  -  Radiant Quest Marker

  Builds the override plugins. Touches exactly one subrecord per quest:
  QUST \ FULL - Name. Nothing else is copied as new, edited or removed.

  Input   : <xEdit>\Edit Scripts\RadiantQuestMarker\quests.tsv
  Output  : new plugins in the load order (save them from xEdit afterwards)
            <xEdit>\Edit Scripts\RadiantQuestMarker\output\generate_report.txt

  quests.tsv columns, pipe delimited:
    0 formID  1 editorID  2 originalName  3 tag       4 category
    5 faction 6 dlc       7 repeatable    8 timed     9 settlementRelated
   10 sourcePlugin 11 module 12 confidence 13 evidence

  Matching order per row: editorID, then formID+sourcePlugin, then exact
  originalName. First hit wins; a row that matches nothing is reported, never
  guessed at.

  Configure the three constants below, run once per tag style, and move the
  saved plugins into Plugins\Descriptive\ or Plugins\Compact\ between runs.
}
unit UserScript;

const
  DB_SUBDIR         = 'RadiantQuestMarker\';

  // ---- configuration -----------------------------------------------------
  TAG_STYLE         = 'compact';       // 'descriptive' or 'compact'
  ALLOW_UNVERIFIED  = False;           // tag rows marked 'unverified' too
  USE_WINNING_OVERRIDE = False;        // False = copy from the official master,
                                       // True  = copy from the current winner so
                                       //         other mods' QUST edits are kept
                                       //         (adds those mods as masters)
  FLAG_AS_ESL       = True;            // override-only plugins are always ESL safe
  RADIANTS_TO_MISC  = False;           // False = preserve vanilla quest categories (do not force to Miscellaneous)
  TAG_OBJECTIVES    = False;           // False = preserve vanilla objective subrecords
  DRY_RUN           = False;           // report only, create nothing
  // ------------------------------------------------------------------------

var
  slDb, slTags, slStrip, slReport, slModules: TStringList;
  outDir: string;
  cModified, cSkipUnverified, cSkipExcluded, cSkipDisabled,
  cNotFound, cMissingMaster, cWarn, cAlreadyTagged, cObjsModified: integer;

// ---------------------------------------------------------------- helpers

function EnsureDir(const p: string): string;
begin
  if not DirectoryExists(p) then ForceDirectories(p);
  Result := p;
end;

function ContainsCI(const h, n: string): boolean;
begin
  Result := Pos(LowerCase(n), LowerCase(h)) > 0;
end;

function StartsCI(const s, p: string): boolean;
begin
  Result := Pos(LowerCase(p), LowerCase(s)) = 1;
end;

function BoolToStr(b: boolean; dummy: boolean): string;
begin
  if b then Result := 'True' else Result := 'False';
end;

function SafeEditValue(e: IInterface; const path: string): string;
begin
  try
    Result := GetElementEditValues(e, path);
  except
    Result := '';
  end;
end;

function Field(const row: string; idx: integer): string;
var f: TStringList;
begin
  Result := '';
  f := TStringList.Create;
  try
    f.Delimiter := '|';
    f.StrictDelimiter := True;
    f.DelimitedText := row;
    if idx < f.Count then Result := Trim(f[idx]);
  finally
    f.Free;
  end;
end;

// Tag vocabulary, mirrored from Database/aliases.json.
procedure LoadTags;
begin
  slTags  := TStringList.Create;
  slStrip := TStringList.Create;

  if TAG_STYLE = 'compact' then begin
    slTags.Values['main']                     := '[M]';
    slTags.Values['bos']                      := '[BOS]';
    slTags.Values['bos_main']                 := '[BOS]';
    slTags.Values['inst']                     := '[INST]';
    slTags.Values['inst_main']                := '[INST]';
    slTags.Values['mm']                       := '[MM]';
    slTags.Values['mm_main']                  := '[MM]';
    slTags.Values['rr']                       := '[RR]';
    slTags.Values['rr_main']                  := '[RR]';
    slTags.Values['bos_side']                 := '[BOS-S]';
    slTags.Values['inst_side']                := '[INST-S]';
    slTags.Values['mm_side']                  := '[MM-S]';
    slTags.Values['rr_side']                  := '[RR-S]';
    slTags.Values['side']                     := '[S]';
    slTags.Values['radiant']                  := '[R]';
    slTags.Values['minutemen_radiant']        := '[R]';
    slTags.Values['brotherhood_radiant']      := '[R]';
    slTags.Values['railroad_radiant']         := '[R]';
    slTags.Values['institute_radiant']        := '[R]';
    slTags.Values['farharbor']                := '[R]';
    slTags.Values['farharbor_main']           := '[DLC]';
    slTags.Values['farharbor_radiant']        := '[R]';
    slTags.Values['nukaworld']                := '[R]';
    slTags.Values['nukaworld_main']           := '[DLC]';
    slTags.Values['nukaworld_radiant']        := '[R]';
    slTags.Values['automatron']               := '[R]';
    slTags.Values['automatron_main']          := '[DLC]';
    slTags.Values['automatron_radiant']       := '[R]';
    slTags.Values['vaulttec']                 := '[R]';
    slTags.Values['vaulttec_main']            := '[DLC]';
    slTags.Values['vaulttec_radiant']         := '[R]';
    slTags.Values['dlc']                      := '[DLC]';
    slTags.Values['settlement_radiant']       := '[R]';
    slTags.Values['settlement_establishment'] := '[R]';
    slTags.Values['timed_radiant']            := '[R]';
    slTags.Values['timed']                    := '[R]';
    slTags.Values['settlement_defense']       := '[R]';
    slTags.Values['defend']                   := '[R]';
    slTags.Values['nextgen']                  := '[CC]';
    slTags.Values['cc']                       := '[CC]';
  end else begin
    slTags.Values['main']                     := '[Main]';
    slTags.Values['bos']                      := '[Brotherhood of Steel]';
    slTags.Values['bos_main']                 := '[Brotherhood of Steel]';
    slTags.Values['inst']                     := '[Institute]';
    slTags.Values['inst_main']                := '[Institute]';
    slTags.Values['mm']                       := '[Minutemen]';
    slTags.Values['mm_main']                  := '[Minutemen]';
    slTags.Values['rr']                       := '[Railroad]';
    slTags.Values['rr_main']                  := '[Railroad]';
    slTags.Values['bos_side']                 := '[Brotherhood Side Quest]';
    slTags.Values['inst_side']                := '[Institute Side Quest]';
    slTags.Values['mm_side']                  := '[Minutemen Side Quest]';
    slTags.Values['rr_side']                  := '[Railroad Side Quest]';
    slTags.Values['side']                     := '[Side Quest]';
    slTags.Values['radiant']                  := '[Radiant]';
    slTags.Values['minutemen_radiant']        := '[Radiant]';
    slTags.Values['brotherhood_radiant']      := '[Radiant]';
    slTags.Values['railroad_radiant']         := '[Radiant]';
    slTags.Values['institute_radiant']        := '[Radiant]';
    slTags.Values['farharbor']                := '[Radiant]';
    slTags.Values['farharbor_main']           := '[DLC]';
    slTags.Values['farharbor_radiant']        := '[Radiant]';
    slTags.Values['nukaworld']                := '[Radiant]';
    slTags.Values['nukaworld_main']           := '[DLC]';
    slTags.Values['nukaworld_radiant']        := '[Radiant]';
    slTags.Values['automatron']               := '[Radiant]';
    slTags.Values['automatron_main']          := '[DLC]';
    slTags.Values['automatron_radiant']       := '[Radiant]';
    slTags.Values['vaulttec']                 := '[Radiant]';
    slTags.Values['vaulttec_main']            := '[DLC]';
    slTags.Values['vaulttec_radiant']         := '[Radiant]';
    slTags.Values['dlc']                      := '[DLC]';
    slTags.Values['settlement_radiant']       := '[Radiant]';
    slTags.Values['settlement_establishment'] := '[Radiant]';
    slTags.Values['timed_radiant']            := '[Radiant]';
    slTags.Values['timed']                    := '[Radiant]';
    slTags.Values['settlement_defense']       := '[Radiant]';
    slTags.Values['defend']                   := '[Radiant]';
    slTags.Values['nextgen']                  := '[Creation Club]';
    slTags.Values['cc']                       := '[Creation Club]';
  end;

  // Every tag from BOTH styles is strippable, longest first. This is what
  // makes re-running idempotent and lets a user switch styles cleanly.
  slStrip.Add('[Brotherhood Side Quest]');
  slStrip.Add('[Minutemen Side Quest]');
  slStrip.Add('[Institute Side Quest]');
  slStrip.Add('[Railroad Side Quest]');
  slStrip.Add('[Minutemen - Settlement Defense]');
  slStrip.Add('[Settlement - Establishment]');
  slStrip.Add('[Brotherhood of Steel]');
  slStrip.Add('[Brotherhood - Radiant]');
  slStrip.Add('[Far Harbor - Radiant]');
  slStrip.Add('[Automatron - Radiant]');
  slStrip.Add('[Nuka-World - Radiant]');
  slStrip.Add('[Settlement - Radiant]');
  slStrip.Add('[Institute - Radiant]');
  slStrip.Add('[Minutemen - Radiant]');
  slStrip.Add('[Vault-Tec - Radiant]');
  slStrip.Add('[Railroad - Radiant]');
  slStrip.Add('[Institute - Main]');
  slStrip.Add('[Railroad - Main]');
  slStrip.Add('[Minutemen - Main]');
  slStrip.Add('[Settlement Defense]');
  slStrip.Add('[Creation Club]');
  slStrip.Add('[BoS - Main]');
  slStrip.Add('[Timed - Radiant]');
  slStrip.Add('[Side Quest]');
  slStrip.Add('[Brotherhood]');
  slStrip.Add('[Nuka-World]');
  slStrip.Add('[Automatron]');
  slStrip.Add('[Far Harbor]');
  slStrip.Add('[Vault-Tec]');
  slStrip.Add('[Minutemen]');
  slStrip.Add('[Institute]');
  slStrip.Add('[Next-Gen]');
  slStrip.Add('[Railroad]');
  slStrip.Add('[Radiant]');
  slStrip.Add('[Settlement]');
  slStrip.Add('[Defend]');
  slStrip.Add('[Timed]');
  slStrip.Add('[INST-S]');
  slStrip.Add('[BOS-S]');
  slStrip.Add('[MM-DEF]');
  slStrip.Add('[SET-DEF]');
  slStrip.Add('[MM-S]');
  slStrip.Add('[RR-S]');
  slStrip.Add('[Side]');
  slStrip.Add('[Main]');
  slStrip.Add('[INST]');
  slStrip.Add('[R-INT]');
  slStrip.Add('[R-SET]');
  slStrip.Add('[R-BOS]');
  slStrip.Add('[R-MM]');
  slStrip.Add('[R-NW]');
  slStrip.Add('[R-VW]');
  slStrip.Add('[R-AT]');
  slStrip.Add('[R-FH]');
  slStrip.Add('[R-RR]');
  slStrip.Add('[BOS]');
  slStrip.Add('[BoS]');
  slStrip.Add('[DEF]');
  slStrip.Add('[DLC]');
  slStrip.Add('[Inst]');
  slStrip.Add('[FH]');
  slStrip.Add('[MM]');
  slStrip.Add('[NW]');
  slStrip.Add('[NG]');
  slStrip.Add('[RR]');
  slStrip.Add('[VW]');
  slStrip.Add('[AT]');
  slStrip.Add('[CC]');
  slStrip.Add('[M]');
  slStrip.Add('[R]');
  slStrip.Add('[S]');
  slStrip.Add('[T]');
  slStrip.Add('[D]');
end;

// Removes any tag this mod knows about from the front of a name.
// A name that starts with an unrelated bracket is left untouched.
function StripKnownTags(const s: string): string;
var
  i: integer;
  changed: boolean;
  t: string;
begin
  Result := Trim(s);
  repeat
    changed := False;
    for i := 0 to Pred(slStrip.Count) do begin
      t := slStrip[i];
      if StartsCI(Result, t) then begin
        Result  := Trim(Copy(Result, Length(t) + 1, Length(Result)));
        changed := True;
        Break;
      end;
    end;
  until not changed;
end;

// Tags all NNAM display text subrecords within the quest's Objectives list.
// Crucial for Pip-Boy Miscellaneous quests where the quest FULL name is hidden
// and only the individual objective lines are displayed on screen.
function TagObjectives(ovr: IInterface; const tagText: string): integer;
var
  objs, obj, nnam: IInterface;
  j: integer;
  oldObj, baseObj, newObj: string;
begin
  Result := 0;
  try
    objs := ElementByName(ovr, 'Objectives');
    if not Assigned(objs) then Exit;
    for j := 0 to Pred(ElementCount(objs)) do begin
      obj := ElementByIndex(objs, j);
      nnam := ElementBySignature(obj, 'NNAM');
      if Assigned(nnam) then begin
        oldObj := Trim(GetEditValue(nnam));
        if oldObj <> '' then begin
          baseObj := StripKnownTags(oldObj);
          newObj := tagText + ' ' + baseObj;
          if oldObj <> newObj then begin
            SetEditValue(nnam, newObj);
            Inc(Result);
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      AddMessage('    Warning tagging objectives: ' + E.Message);
  end;
end;

function ModulePlugin(const m: string): string;
begin
  if      m = 'Main'       then Result := 'QuestMarkers_Main.esp'
  else if m = 'Radiant'    then Result := 'QuestMarkers_Radiant.esp'
  else if m = 'Defend'     then Result := 'QuestMarkers_Defend.esp'
  else if m = 'Timed'      then Result := 'QuestMarkers_Timed.esp'
  else if m = 'Vanilla'    then Result := 'QuestMarkers_Vanilla.esp'
  else if m = 'Settlement' then Result := 'QuestMarkers_Settlement.esp'
  else if m = 'Automatron' then Result := 'QuestMarkers_Automatron.esp'
  else if m = 'FarHarbor'  then Result := 'QuestMarkers_FarHarbor.esp'
  else if m = 'NukaWorld'  then Result := 'QuestMarkers_NukaWorld.esp'
  else if m = 'VaultTec'   then Result := 'QuestMarkers_VaultTec.esp'
  else if m = 'OtherDLC'   then Result := 'QuestMarkers_OtherDLC.esp'
  else if m = 'NextGen'    then Result := 'QuestMarkers_NextGen.esp'
  else Result := 'QuestMarkers_' + m + '.esp';
end;

function FindLoadedFile(const nm: string): IInterface;
var i: integer;
begin
  Result := nil;
  for i := 0 to Pred(FileCount) do
    if LowerCase(GetFileName(FileByIndex(i))) = LowerCase(nm) then begin
      Result := FileByIndex(i);
      Exit;
    end;
end;

// Creates the module plugin on first use and caches it in slModules.
function GetModuleFile(const m: string): IInterface;
var
  fname: string;
  f, hdr: IInterface;
  idx: integer;
begin
  Result := nil;
  fname := ModulePlugin(m);
  if fname = '' then Exit;

  idx := slModules.IndexOf(m);
  if idx >= 0 then begin
    Result := ObjectToElement(slModules.Objects[idx]);
    Exit;
  end;

  f := FindLoadedFile(fname);
  if not Assigned(f) then
    f := AddNewFileName(fname);
  if not Assigned(f) then begin
    AddMessage('  ERROR: could not create ' + fname);
    Exit;
  end;

  hdr := ElementByIndex(f, 0);
  SetElementEditValues(hdr, 'CNAM', 'Radiant Quest Marker');
  SetElementEditValues(hdr, 'SNAM',
    'Quest log categorisation for ' + m + '. Display names only - no scripts, stages, aliases or rewards touched.');
  AddMasterIfMissing(f, 'Fallout4.esm');
  if FLAG_AS_ESL then begin
    try
      SetIsESL(f, True);
    except
      AddMessage('  note: could not set the ESL flag on ' + fname + ' (older xEdit?). Set it manually.');
    end;
  end;

  slModules.AddObject(m, f);
  Result := f;
  AddMessage('  created module plugin: ' + fname);
end;

// ------------------------------------------------------- record resolution

function FindQuestByEditorID(const edid, srcName: string): IInterface;
var
  fi, gi: integer;
  f, grp, rec: IInterface;
begin
  Result := nil;
  if edid = '' then Exit;
  for fi := 0 to Pred(FileCount) do begin
    f := FileByIndex(fi);
    if StartsCI(GetFileName(f), 'QuestMarkers_') then Continue;
    if (srcName <> '') and (LowerCase(GetFileName(f)) <> LowerCase(srcName)) then Continue;
    grp := GroupBySignature(f, 'QUST');
    if not Assigned(grp) then Continue;
    for gi := 0 to Pred(ElementCount(grp)) do begin
      rec := ElementByIndex(grp, gi);
      if not Equals(MasterOrSelf(rec), rec) then Continue;
      if LowerCase(EditorID(rec)) = LowerCase(edid) then begin
        Result := rec;
        Exit;
      end;
    end;
  end;
end;

function FindQuestByName(const nm, srcName: string; var ambiguous: boolean): IInterface;
var
  fi, gi, hits: integer;
  f, grp, rec: IInterface;
begin
  Result := nil;
  ambiguous := False;
  hits := 0;
  if nm = '' then Exit;
  for fi := 0 to Pred(FileCount) do begin
    f := FileByIndex(fi);
    if StartsCI(GetFileName(f), 'QuestMarkers_') then Continue;
    if (srcName <> '') and (LowerCase(GetFileName(f)) <> LowerCase(srcName)) then Continue;
    grp := GroupBySignature(f, 'QUST');
    if not Assigned(grp) then Continue;
    for gi := 0 to Pred(ElementCount(grp)) do begin
      rec := ElementByIndex(grp, gi);
      if not Equals(MasterOrSelf(rec), rec) then Continue;
      if LowerCase(Trim(GetElementEditValues(rec, 'FULL'))) = LowerCase(Trim(nm)) then begin
        Inc(hits);
        if hits = 1 then Result := rec;
      end;
    end;
  end;
  ambiguous := hits > 1;
end;

// Resolves a source plugin name that may be a cc*.esl wildcard pattern.
function ResolveSourceName(const pat: string): string;
var
  i: integer;
  stem, nm: string;
begin
  Result := pat;
  if Pos('*', pat) = 0 then Exit;
  // pattern form is cc*Token*.esl - match on the middle token
  stem := pat;
  Delete(stem, 1, Pos('*', stem));
  if Pos('*', stem) > 0 then SetLength(stem, Pos('*', stem) - 1);
  Result := '';
  if stem = '' then Exit;
  for i := 0 to Pred(FileCount) do begin
    nm := GetFileName(FileByIndex(i));
    if StartsCI(nm, 'cc') and ContainsCI(nm, stem) then begin
      Result := nm;
      Exit;
    end;
  end;
end;

// ---------------------------------------------------------------- main

function Initialize: integer;
var
  path, row, edid, nm, tagKey, cat, isRep, modul, conf, srcPat, srcName, tagText,
  oldName, baseName, newName, currType: string;
  i, objCount: integer;
  rec, tgt, ovr: IInterface;
  ambiguous, toMisc, needTypeChange, isMiscQuest: boolean;
begin
  Result := 0;
  cModified := 0; cSkipUnverified := 0; cSkipExcluded := 0; cSkipDisabled := 0;
  cNotFound := 0; cMissingMaster := 0; cWarn := 0; cAlreadyTagged := 0; cObjsModified := 0;

  outDir := EnsureDir(ScriptsPath + DB_SUBDIR + 'output\');
  LoadTags;
  slModules := TStringList.Create;
  slReport  := TStringList.Create;
  slDb      := TStringList.Create;

  path := ScriptsPath + DB_SUBDIR + 'quests.tsv';
  if not FileExists(path) then begin
    AddMessage('ERROR: database not found at ' + path);
    AddMessage('Run build\package.py to generate quests.tsv from Database\quests.json.');
    Result := 1;
    Exit;
  end;
  slDb.LoadFromFile(path);

  slReport.Add('=== Radiant Quest Marker :: Generation Report ===');
  slReport.Add('Tag style        : ' + TAG_STYLE);
  slReport.Add('Allow unverified : ' + BoolToStr(ALLOW_UNVERIFIED, True));
  slReport.Add('Copy source      : ' + BoolToStr(USE_WINNING_OVERRIDE, True));
  slReport.Add('Radiants to misc : ' + BoolToStr(RADIANTS_TO_MISC, True));
  slReport.Add('Dry run          : ' + BoolToStr(DRY_RUN, True));
  slReport.Add('');

  for i := 0 to Pred(slDb.Count) do begin
    row := Trim(slDb[i]);
    if (row = '') or (Copy(row, 1, 1) = '#') then Continue;

    edid    := Field(row, 1);
    nm      := Field(row, 2);
    tagKey  := Field(row, 3);
    cat     := Field(row, 4);
    isRep   := LowerCase(Field(row, 7));
    srcPat  := Field(row, 10);
    modul   := Field(row, 11);
    conf    := LowerCase(Field(row, 12));
    toMisc  := RADIANTS_TO_MISC and ((cat = 'Radiant') or (cat = 'Settlement Defense') or (isRep = 'true'));

    if (conf = 'excluded') or (tagKey = '') or (modul = '') then begin
      Inc(cSkipExcluded);
      slReport.Add('EXCLUDED | ' + nm + ' | ' + Field(row, 13));
      Continue;
    end;

    if (conf = 'unverified') and not ALLOW_UNVERIFIED then begin
      Inc(cSkipUnverified);
      slReport.Add('SKIP     | ' + nm + ' | confidence=unverified, not confirmed repeatable');
      Continue;
    end;

    srcName := ResolveSourceName(srcPat);
    if srcName = '' then begin
      Inc(cMissingMaster);
      slReport.Add('NOMASTER | ' + nm + ' | no loaded plugin matches ' + srcPat);
      Continue;
    end;
    if not Assigned(FindLoadedFile(srcName)) then begin
      Inc(cMissingMaster);
      slReport.Add('NOMASTER | ' + nm + ' | ' + srcName + ' is not loaded - module ' + modul + ' will be skipped');
      Continue;
    end;

    rec := FindQuestByEditorID(edid, srcName);
    if not Assigned(rec) then begin
      rec := FindQuestByName(nm, srcName, ambiguous);
      if ambiguous then begin
        Inc(cWarn);
        slReport.Add('WARNING  | ' + nm + ' | several records share this display name; add the EditorID to the database');
      end;
    end;

    if not Assigned(rec) then begin
      Inc(cNotFound);
      slReport.Add('NOTFOUND | ' + nm + ' | no QUST match in ' + srcName);
      Continue;
    end;

    tagText := slTags.Values[tagKey];
    if tagText = '' then begin
      Inc(cWarn);
      slReport.Add('WARNING  | ' + nm + ' | unknown tag key "' + tagKey + '"');
      Continue;
    end;

    if USE_WINNING_OVERRIDE then
      oldName := GetElementEditValues(WinningOverride(rec), 'FULL')
    else
      oldName := GetElementEditValues(rec, 'FULL');

    baseName := StripKnownTags(oldName);
    newName  := tagText + ' ' + baseName;

    currType := '';
    if USE_WINNING_OVERRIDE then
      currType := SafeEditValue(WinningOverride(rec), 'DNAM\Type')
    else
      currType := SafeEditValue(rec, 'DNAM\Type');

    needTypeChange := toMisc and (currType <> 'Miscellaneous');

    if (oldName = newName) and (not needTypeChange) and (not TAG_OBJECTIVES) then begin
      Inc(cAlreadyTagged);
      slReport.Add('NOCHANGE | ' + newName + ' | already tagged correctly');
      Continue;
    end;

    if DRY_RUN then begin
      Inc(cModified);
      if toMisc then
        slReport.Add('WOULD    | ' + modul + ' | ' + oldName + '  ->  ' + newName + ' [MISC]')
      else
        slReport.Add('WOULD    | ' + modul + ' | ' + oldName + '  ->  ' + newName);
      Continue;
    end;

    tgt := GetModuleFile(modul);
    if not Assigned(tgt) then begin
      Inc(cSkipDisabled);
      slReport.Add('SKIP     | ' + nm + ' | module ' + modul + ' unavailable');
      Continue;
    end;

    if USE_WINNING_OVERRIDE then begin
      AddMasterIfMissing(tgt, GetFileName(GetFile(WinningOverride(rec))));
      AddRequiredElementMasters(WinningOverride(rec), tgt, False);
      ovr := wbCopyElementToFile(WinningOverride(rec), tgt, False, True);
    end else begin
      AddMasterIfMissing(tgt, GetFileName(GetFile(rec)));
      AddRequiredElementMasters(rec, tgt, False);
      ovr := wbCopyElementToFile(rec, tgt, False, True);
    end;

    if not Assigned(ovr) then
      ovr := RecordByFormID(tgt, FormID(rec), False);

    if not Assigned(ovr) then begin
      Inc(cWarn);
      slReport.Add('WARNING  | ' + nm + ' | copy to ' + ModulePlugin(modul) + ' failed');
      Continue;
    end;

    SetElementEditValues(ovr, 'FULL', newName);

    objCount := 0;
    isMiscQuest := (currType = 'None') or (currType = 'Miscellaneous') or (oldName = '') or (toMisc);
    if TAG_OBJECTIVES or isMiscQuest then begin
      objCount := TagObjectives(ovr, tagText);
      cObjsModified := cObjsModified + objCount;
    end;

    // Preserve vanilla DNAM\Type: do not force radiants to Miscellaneous.
    // Quests designed for Miscellaneous stay in Miscellaneous, standalone radiants stay outside.

    Inc(cModified);
    if toMisc then
      slReport.Add('OK       | ' + modul + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' +
                   EditorID(rec) + ' | ' + oldName + '  ->  ' + newName + ' [MISC] (' + IntToStr(objCount) + ' objs tagged)')
    else
      slReport.Add('OK       | ' + modul + ' | ' + IntToHex(FixedFormID(rec), 8) + ' | ' +
                   EditorID(rec) + ' | ' + oldName + '  ->  ' + newName + ' (' + IntToStr(objCount) + ' objs tagged)');
  end;

  slReport.Add('');
  slReport.Add('=== Quest Marker Generator ===');
  slReport.Add('');
  slReport.Add('Modified quests        : ' + IntToStr(cModified));
  slReport.Add('Modified objectives    : ' + IntToStr(cObjsModified));
  slReport.Add('Already correct        : ' + IntToStr(cAlreadyTagged));
  slReport.Add('Skipped (unverified)   : ' + IntToStr(cSkipUnverified));
  slReport.Add('Skipped (excluded)     : ' + IntToStr(cSkipExcluded));
  slReport.Add('Skipped (module off)   : ' + IntToStr(cSkipDisabled));
  slReport.Add('Not found in records   : ' + IntToStr(cNotFound));
  slReport.Add('Missing masters        : ' + IntToStr(cMissingMaster));
  slReport.Add('Warnings               : ' + IntToStr(cWarn));
  slReport.Add('Modules created        : ' + IntToStr(slModules.Count));
  slReport.Add('');
  slReport.Add('Generation complete.');
  slReport.SaveToFile(outDir + 'generate_report_' + TAG_STYLE + '.txt');

  AddMessage('');
  for i := 0 to Pred(slReport.Count) do
    if Pos('===', slReport[i]) > 0 then AddMessage(slReport[i]);
  AddMessage('Modified ' + IntToStr(cModified) + ', skipped ' + IntToStr(cSkipUnverified + cSkipExcluded) +
             ', not found ' + IntToStr(cNotFound) + ', missing masters ' + IntToStr(cMissingMaster) +
             ', warnings ' + IntToStr(cWarn) + '.');
  AddMessage('Full report: ' + outDir + 'generate_report_' + TAG_STYLE + '.txt');
  if not DRY_RUN then
    AddMessage('Now save the new plugins from xEdit, then move them into Plugins\' + TAG_STYLE + '\.');
end;

function Process(e: IInterface): integer;
begin
  Result := 0;
end;

function Finalize: integer;
begin
  if Assigned(slDb)      then slDb.Free;
  if Assigned(slTags)    then slTags.Free;
  if Assigned(slStrip)   then slStrip.Free;
  if Assigned(slReport)  then slReport.Free;
  if Assigned(slModules) then slModules.Free;
  Result := 0;
end;

end.
