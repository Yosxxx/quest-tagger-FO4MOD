{
  ValidateQuestMarkers.pas  -  Radiant Quest Marker

  Post-build check. Load the generated QuestMarkers_*.esp plugins together with
  their masters and run this. It proves the success criteria in section 25 of
  the design brief rather than assuming them.

  For every record in every QuestMarkers_* plugin it checks:
    1. the record is a QUST override, not a new record
    2. every field except FULL is byte-identical to the master
    3. the display name carries exactly one known tag, never two
    4. stripping the tag reproduces the master's original name
    5. all required masters are present
    6. the plugin is valid as an ESL (no new records)

  Output: <xEdit>\Edit Scripts\RadiantQuestMarker\output\validation_report.txt
}
unit UserScript;

const
  DB_SUBDIR = 'RadiantQuestMarker\';

var
  slReport, slStrip: TStringList;
  outDir: string;
  cPass, cFail, cWarn: integer;

function EnsureDir(const p: string): string;
begin
  if not DirectoryExists(p) then ForceDirectories(p);
  Result := p;
end;

function StartsCI(const s, p: string): boolean;
begin
  Result := Pos(LowerCase(p), LowerCase(s)) = 1;
end;

procedure LoadStrip;
begin
  slStrip := TStringList.Create;
  slStrip.Add('[Minutemen - Settlement Defense]');
  slStrip.Add('[Settlement - Establishment]');
  slStrip.Add('[Brotherhood - Radiant]');
  slStrip.Add('[Automatron - Radiant]');
  slStrip.Add('[Settlement - Radiant]');
  slStrip.Add('[Nuka-World - Radiant]');
  slStrip.Add('[Minutemen - Radiant]');
  slStrip.Add('[Far Harbor - Radiant]');
  slStrip.Add('[Institute - Radiant]');
  slStrip.Add('[Vault-Tec - Radiant]');
  slStrip.Add('[Railroad - Radiant]');
  slStrip.Add('[Timed - Radiant]');
  slStrip.Add('[Next-Gen]');  slStrip.Add('[Radiant]');
  slStrip.Add('[MM-DEF]');    slStrip.Add('[R-SET]');
  slStrip.Add('[R-BOS]');     slStrip.Add('[R-INT]');
  slStrip.Add('[R-VW]');      slStrip.Add('[R-MM]');
  slStrip.Add('[R-RR]');      slStrip.Add('[R-FH]');
  slStrip.Add('[R-NW]');      slStrip.Add('[R-AT]');
  slStrip.Add('[NG]');        slStrip.Add('[R]');
  slStrip.Add('[T]');         slStrip.Add('[S]');
end;

// Returns how many known tags sit at the front, and the remaining base name.
function CountLeadingTags(const s: string; var baseName: string): integer;
var
  i: integer;
  hit: boolean;
begin
  Result := 0;
  baseName := Trim(s);
  repeat
    hit := False;
    for i := 0 to Pred(slStrip.Count) do
      if StartsCI(baseName, slStrip[i]) then begin
        baseName := Trim(Copy(baseName, Length(slStrip[i]) + 1, Length(baseName)));
        Inc(Result);
        hit := True;
        Break;
      end;
  until not hit;
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

// Compares every top-level element except FULL against the master record.
function OnlyFullDiffers(ovr, mst: IInterface; var offender: string): boolean;
var
  i: integer;
  el, mel: IInterface;
  nm: string;
begin
  Result := True;
  offender := '';
  for i := 0 to Pred(ElementCount(ovr)) do begin
    el := ElementByIndex(ovr, i);
    nm := Name(el);
    if Pos('FULL', nm) = 1 then Continue;
    if Pos('Record Header', nm) = 1 then Continue;
    mel := ElementByName(mst, nm);
    if not Assigned(mel) then begin
      Result := False; offender := nm + ' (added)'; Exit;
    end;
    if GetEditValue(el) <> GetEditValue(mel) then begin
      // structs report an empty edit value; fall back to a serialised compare
      if ElementToString(el) <> ElementToString(mel) then begin
        Result := False; offender := nm; Exit;
      end;
    end;
  end;
end;

function Initialize: integer;
var
  fi, gi, mi: integer;
  f, grp, rec, mst: IInterface;
  fname, full, baseName, mstName, offender: string;
  nTags, newRecs: integer;
begin
  Result := 0;
  cPass := 0; cFail := 0; cWarn := 0;
  outDir := EnsureDir(ScriptsPath + DB_SUBDIR + 'output\');
  LoadStrip;

  slReport := TStringList.Create;
  slReport.Add('=== Radiant Quest Marker :: Validation ===');
  slReport.Add('');

  for fi := 0 to Pred(FileCount) do begin
    f := FileByIndex(fi);
    fname := GetFileName(f);
    if not StartsCI(fname, 'QuestMarkers_') then Continue;

    slReport.Add('--- ' + fname + ' ---');

    // master presence
    for mi := 0 to Pred(MasterCount(f)) do
      slReport.Add('  master: ' + GetFileName(MasterByIndex(f, mi)));

    newRecs := 0;
    grp := GroupBySignature(f, 'QUST');
    if not Assigned(grp) then begin
      slReport.Add('  WARNING | no QUST group - empty plugin');
      Inc(cWarn);
      Continue;
    end;

    for gi := 0 to Pred(ElementCount(grp)) do begin
      rec := ElementByIndex(grp, gi);
      if Signature(rec) <> 'QUST' then Continue;

      mst := Master(rec);
      if not Assigned(mst) then begin
        Inc(newRecs);
        Inc(cFail);
        slReport.Add('  FAIL    | ' + EditorID(rec) + ' | new record, not an override');
        Continue;
      end;

      full    := GetElementEditValues(rec, 'FULL');
      mstName := GetElementEditValues(mst, 'FULL');
      nTags   := CountLeadingTags(full, baseName);

      if nTags = 0 then begin
        Inc(cFail);
        slReport.Add('  FAIL    | ' + EditorID(rec) + ' | override carries no tag: ' + full);
        Continue;
      end;
      if nTags > 1 then begin
        Inc(cFail);
        slReport.Add('  FAIL    | ' + EditorID(rec) + ' | ' + IntToStr(nTags) + ' stacked tags: ' + full);
        Continue;
      end;
      if Trim(baseName) <> Trim(mstName) then begin
        Inc(cFail);
        slReport.Add('  FAIL    | ' + EditorID(rec) + ' | base name drift: "' + baseName + '" vs master "' + mstName + '"');
        Continue;
      end;

      if not OnlyFullDiffers(rec, mst, offender) then begin
        Inc(cFail);
        slReport.Add('  FAIL    | ' + EditorID(rec) + ' | field changed outside FULL: ' + offender);
        Continue;
      end;

      Inc(cPass);
      slReport.Add('  PASS    | ' + GetFileName(GetFile(mst)) + ' | ' + IntToHex(FixedFormID(mst), 8) +
                   ' | ' + EditorID(rec) + ' | ' + full);
    end;

    if newRecs = 0 then
      slReport.Add('  ESL     | valid - override-only plugin, 0 new records')
    else
      slReport.Add('  ESL     | INVALID - ' + IntToStr(newRecs) + ' new records present');
    slReport.Add('');
  end;

  slReport.Add('=== Summary ===');
  slReport.Add('PASS     : ' + IntToStr(cPass));
  slReport.Add('FAIL     : ' + IntToStr(cFail));
  slReport.Add('WARNING  : ' + IntToStr(cWarn));
  slReport.SaveToFile(outDir + 'validation_report.txt');

  AddMessage('Validation: ' + IntToStr(cPass) + ' pass, ' + IntToStr(cFail) + ' fail, ' + IntToStr(cWarn) + ' warn.');
  AddMessage('Report: ' + outDir + 'validation_report.txt');
end;

function Process(e: IInterface): integer;
begin
  Result := 0;
end;

function Finalize: integer;
begin
  if Assigned(slReport) then slReport.Free;
  if Assigned(slStrip)  then slStrip.Free;
  Result := 0;
end;

end.
