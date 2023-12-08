unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math.Vectors, System.Actions, System.ImageList,
  FMX.Types, FMX.Types3D, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls3D, FMX.MaterialSources, FMX.Ani, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ImgList, FMX.ActnList, FMX.Objects3D, FMX.Objects,

  Gorilla.Viewport, Gorilla.Plane, Gorilla.Control, Gorilla.Transform,
  Gorilla.Mesh, Gorilla.Cube, Gorilla.SkyBox, Gorilla.Light,
  Gorilla.Material.Default, Gorilla.Material.Lambert, Gorilla.Model,
  Gorilla.Utils.Pathfinding, Gorilla.Utils.Pathfinding.AStar,
  Gorilla.Utils.Path, Gorilla.Camera, Gorilla.Controller.Input.TriggerPoint,
  Gorilla.Utils.Dialogue.Types, Gorilla.Utils.Dialogue.System,
  Gorilla.UI.Dialogue.Overlay, Gorilla.Controller, Gorilla.Utils.Inventory,
  Gorilla.UI.Inventory, Gorilla.Sphere, Gorilla.Material.POM, Gorilla.Material.PBR,
  Gorilla.Audio.FMOD, Gorilla.Audio.FMOD.Intf.Channel, Gorilla.Audio.FMOD.Intf.Sound,
  Gorilla.Audio.FMOD.Intf.ChannelGroup, Gorilla.Audio.FMOD.Intf.SoundGroup;

/// <summary>
/// After v1.0.0.2573 the dialogue HUD was fixed. Before that version, we need
/// workaround.
/// </summary>
{$DEFINE FIX_DIALOGUE_HUD}

type
{$IFDEF FIX_DIALOGUE_HUD}
  /// <summary>
  /// Nothing is perfect, so aren't we!
  /// There are various issues with the dialogue HUD in v1.0.0.2573
  /// 1) Character names were overwritten by a default behaviour
  /// 2) Audio event parameter "id", "volume" and "loop-count" cannot be converted
  ///    from TValue to a native type
  /// 3) Dialogue system events getting lost by using the HUD
  /// </summary>
  TFixedDialogueHUD = class(TGorillaDialogueHUD)
    protected
      // Stored events from dialogue system to not delete those
      FStoredEvents : Boolean;

      FStoredOnBeginDialogueItemEvent : TOnBeginDialogueItemEvent;
      FStoredOnEndDialogueItemEvent   : TOnEndDialogueItemEvent;

      FStoredOnBeginDialogueItem : TOnBeginDialogueItem;
      FStoredOnEndDialogueItem   : TOnEndDialogueItem;

      FStoredOnStartDialogue    : TOnStartDialogue;
      FStoredOnStopDialogue     : TOnStopDialogue;
      FStoredOnPauseDialogue    : TOnPauseDialogue;

      FStoredOnSkippedDialogue  : TOnSkippedDialogue;
      FStoredOnSkipAvailability : TOnSkipAvailability;

      FStoredOnBeginItemTimeout : TOnBeginItemTimeout;
      FStoredOnEndItemTimeout   : TOnEndItemTimeout;

      procedure DoExecuteEvent(const AEvent : TGorillaDialogueItemEvent;
        const AScope : TObject); override;

      procedure DoOnStartDialogue(const ADialogue : TGorillaDialogue;
        const AItems : TArray<TGorillaDialogueItem>); override;
      procedure DoOnStopDialogue(const ADialogue : TGorillaDialogue); override;

      procedure DoShowItem(const AItem : TGorillaDialogueItem;
        const ADoStartItem : Boolean); override;

      procedure StoreDialogueSystemEvents(ASystem : TGorillaDialogueSystem); virtual;
      procedure RestoreDialogueSystemEvents(ASystem : TGorillaDialogueSystem);
      procedure SetDialogue(const AValue : TGorillaDialogue); override;
  end;
{$ELSE}
  TFixedDialogueHUD = class(TGorillaDialogueHUD);
{$ENDIF}

  TForm1 = class(TForm)
    GorillaViewport1: TGorillaViewport;
    GorillaLight1: TGorillaLight;
    GorillaSkyBox1: TGorillaSkyBox;
    GorillaPlane1: TGorillaPlane;
    GorillaLambertMaterialSource1: TGorillaLambertMaterialSource;
    Monkey: TGorillaModel;
    GorillaCamera1: TGorillaCamera;
    Landscape: TGorillaModel;
    MonkeyNavigator: TDummy;
    AlphaWall1: TDummy;
    AlphaWall2: TDummy;
    AlphaWall3: TDummy;
    AlphaWall4: TDummy;
    AlphaWall5: TDummy;
    AlphaWall6: TDummy;
    AlphaWall7: TDummy;
    AlphaWall8: TDummy;
    AlphaWalls: TDummy;
    AlphaWall9: TDummy;
    AlphaWall10: TDummy;
    GorillaTriggerPointManager1: TGorillaTriggerPointManager;
    GorillaDialogueSystem1: TGorillaDialogueSystem;
    ToolTipRect: TRoundRect;
    ToolTipText: TLabel;
    GorillaInventory1: TGorillaInventory;
    FloatAnimation1: TFloatAnimation;
    ImageList1: TImageList;
    Banana: TGorillaModel;
    FloatAnimation2: TFloatAnimation;
    CoconutTree: TGorillaModel;
    Coconut: TGorillaModel;
    ActionList1: TActionList;
    ShakeTheTreeAction: TAction;
    CollectBananaAction: TAction;
    CollectCoconutAction: TAction;
    GlowingMonkeyMaterial: TGorillaPBRMaterialSource;
    ColorAnimation1: TColorAnimation;
    CoconutAnim: TFloatAnimation;
    GorillaFMODAudioManager1: TGorillaFMODAudioManager;
    procedure FormCreate(Sender: TObject);
    procedure GorillaViewport1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure GorillaTriggerPointManager1Items0Triggered(
      ASender: TGorillaTriggerPointManager; const APos, AViewDir: TPoint3D;
      const APoint: TGorillaTriggerPoint; const ADistance: Single);
    procedure GorillaViewport1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure ShakeTheTreeActionExecute(Sender: TObject);
    procedure CollectBananaActionExecute(Sender: TObject);
    procedure CollectCoconutActionExecute(Sender: TObject);
    procedure CoconutAnimFinish(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure GorillaDialogueSystem1StopDialogue(
      const ADialogue: TGorillaDialogue);
  private
    FPathFinder : TGorillaPathfindingAStar;
    FPath       : TGorillaPath3D;
    FPathAnim   : TGorillaPath3DAnimation;
    FDestPoint  : TPoint3D;
    FPolygon    : TGorillaPolygon3D;
    FHUD        : TFixedDialogueHUD;
    FCoconutFound : Boolean;
    FBananaUnlocked : Boolean;

    // Audio: a separated channel for each sound is not needed, but for better controlling
    FMusic : IGorillaFMODSound;
    FMusicChannel : IGorillaFMODChannelGroup;

    FSteps : IGorillaFMODSound;
    FStepsChannel : IGorillaFMODChannelGroup;

    FThrow   : IGorillaFMODSound;
    FPlop    : IGorillaFMODSound;
    FCollect : IGorillaFMODSound;
    FThrowChannel : IGorillaFMODChannelGroup;

    function GetYAngleBetweenPoints(A, B : TPoint3D) : Single;

    procedure DoOnPathAnimProcess(ASender : TObject);
    procedure DoOnPathAnimFinished(ASender : TObject);

    // Tooltip interaction on mouse move
    procedure ShowToolTip(AText : String; X, Y: Single);
    procedure HideToolTip();

    function PerformGameObjectToolTip(AObj : TControl3D; AGlobalBounds : Boolean;
      AScreenPos : TPoint3D; ARayStart : TPoint3D; X, Y : Single) : Boolean;
    function PerformGameObjectToolTips(AScreenPos : TPoint3D; ARayStart : TPoint3D;
      X, Y : Single) : Boolean;

    // Inventory collection on click
    function PerformGameObjectClick(AObj : TControl3D; AGlobalBounds : Boolean;
      AScreenPos : TPoint3D; ARayStart : TPoint3D; X, Y : Single;
      AAction : TAction) : Boolean;
    function PerformGameObjectClicks(AScreenPos : TPoint3D; ARayStart : TPoint3D;
      X, Y : Single) : Boolean;

  public
    procedure CreatePBRFiremonkey();
    procedure AddDepthTransparency();
    procedure SetupAudio();
    procedure SetupPathfinding();
    procedure UpdatePathfinding();
    procedure ShowSacredCoconut();
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Math, System.IOUtils, System.Rtti, Gorilla.DefTypes,
  Gorilla.Material.Types, Gorilla.Audio.FMOD.Lib.Common, Gorilla.Audio.FMOD.Custom,
  Gorilla.Audio.FMOD.Intf.DSP, Gorilla.Audio.FMOD.Lib.DSP.Effects;

const
  // Constants for the grid cells: 256 x 256 cells
  PATHFINDING_GRID_X   = 256;
  PATHFINDING_GRID_Z   = 256;
  // We expect the scene to have a maximum size of 128 3D-units
  PATHFINDING_3DSIZE_X = 128;
  PATHFINDING_3DSIZE_Z = 128;

  CLICK_DISTANCE = 2;
  TOOLTIP_DISTANCE = 2;

{$IFDEF FIX_DIALOGUE_HUD}
{ TFixedDialogueHUD }

procedure TFixedDialogueHUD.DoExecuteEvent(const AEvent : TGorillaDialogueItemEvent;
  const AScope : TObject);
var LParamVal  : TValue;
    LAudioMng  : TGorillaFMODAudioManager;
    LChannel   : IGorillaFMODChannel;
    LFltVal    : Single;
    LUInt64Val : UInt64;
    LIntVal,
    LChIdx     : Integer;
    LFormatSettings : TFormatSettings;
    LDelay     : TGorillaFMODDelay;
    LWetDryMix : TGorillaFMODWetDryMix;
    LDSPIdx    : Integer;
    LDSPEffect : IGorillaFMODDSP;
begin
  LFormatSettings := TFormatSettings.Create('en-US');

  case AEvent.Kind of
    Audio:
      begin
        if not Assigned(FAudioManager) then
          Exit;

        if AEvent.Parameters.TryGetValue('id', LParamVal) then
        begin
          LAudioMng := FAudioManager as TGorillaFMODAudioManager;

          // BUGFIX: in v1.0 a conversion error occurs, because TValue could not
          // be converted from string to integer
          if (LParamVal.IsEmpty) or not TryStrToInt(LParamVal.ToString, LChIdx) then
            LChIdx := -1;

          // FIX the TValue
          LParamVal := TValue.From<Integer>(LChIdx);
          AEvent.Parameters.AddOrSetValue('id', LParamVal);

          LChannel := LAudioMng.PlaySound(LChIdx);
          if Assigned(LChannel) then
          begin
            FAudioChannels.AddOrSetValue(LChIdx, LChannel as IInterface);

            // number of loops
            if AEvent.Parameters.TryGetValue('loop-count', LParamVal) then
            begin
              if (not LParamVal.IsEmpty) and TryStrToInt(LParamVal.ToString, LIntVal) then
                LChannel.LoopCount := LIntVal;
            end;

            // volume
            if AEvent.Parameters.TryGetValue('volume', LParamVal) then
            begin
              if (not LParamVal.IsEmpty) and TryStrToFloat(LParamVal.ToString, LFltVal, LFormatSettings) then
                LChannel.Volume := LFltVal
              else
                LChannel.Volume := 0.75;
            end
            else LChannel.Volume := 0.75;

            // pitching (0.0 - 1.0)
            if AEvent.Parameters.TryGetValue('pitch', LParamVal) then
            begin
              if (not LParamVal.IsEmpty) and TryStrToFloat(LParamVal.ToString, LFltVal, LFormatSettings) then
              begin
                LFltVal := Max(0, Min(1, LFltVal));
                LChannel.Pitch := LFltVal;
              end;
            end;

            // delay (start)
            if AEvent.Parameters.TryGetValue('dsp-clock-start', LParamVal) then
            begin
              if (not LParamVal.IsEmpty) and TryStrToUInt64(LParamVal.ToString, LUInt64Val) then
              begin
                LDelay.DSPClock_Start := LUInt64Val;
                LDelay.DSPClock_End := LUInt64Val;
                LDelay.StopChannels := false;

                if AEvent.Parameters.TryGetValue('dsp-clock-end', LParamVal) then
                begin
                  if (not LParamVal.IsEmpty) and TryStrToUInt64(LParamVal.ToString, LUInt64Val) then
                  begin
                    LDelay.DSPClock_End := LUInt64Val;
                  end;
                end;

                // apply delay settings
                LChannel.Delay := LDelay;
              end;
            end;

            // DSP effect by type, index and wetdrymix (1st variation)
            // max. 5 effects
            for LDSPIdx := 1 to 5 do
            begin
              if AEvent.Parameters.TryGetValue(Format('dsp[%d]', [LDSPIdx]), LParamVal) then
              begin
                // get the type of dsp effect by TFMOD_DSPType (as ordinal value)
                if (not LParamVal.IsEmpty) and TryStrToInt(LParamVal.ToString, LIntVal) then
                begin
                  LDSPEffect := LAudioMng.SystemObject.CreateDSPByType(TFMOD_DSPType(LIntVal));
                  LDSPEffect.Active := true;

                  if AEvent.Parameters.TryGetValue(Format('dsp[%d].wetdrymix', [LDSPIdx]), LParamVal) then
                  begin
                    if (not LParamVal.IsEmpty) and TryStrToFloat(LParamVal.ToString, LFltVal, LFormatSettings) then
                    begin
                      LFltVal := Max(0, Min(1, LFltVal));
                      LWetDryMix.PreWet := LFltVal;
                      LWetDryMix.PostWet := LFltVal;
                      LWetDryMix.Dry := 1 - LFltVal;
                      LDSPEffect.WetDryMix := LWetDryMix;
                    end;
                  end;

                  LChannel.AddDSP(LDSPIdx - 1, LDSPEffect);
                end;
              end;
            end;
          end;
        end;
      end;

    else
      inherited DoExecuteEvent(AEvent, AScope);
  end;
end;

procedure TFixedDialogueHUD.DoShowItem(const AItem : TGorillaDialogueItem;
  const ADoStartItem : Boolean);
var LOverlay : TGorillaDialogueOverlay;
begin
  case AItem.Kind of
    TGorillaDialogueItemKind.Question:
      begin
        LOverlay := TGorillaDialogueQuestionOverlay.Create(Self);
        LOverlay.Parent := Self;
        LOverlay.Item := AItem;
        AItem.UIElement := LOverlay;
        LOverlay.Stored := false;
        // BUGFIX: because displayname is overwritten, the wrong character name is set
        TGorillaDialogueTextOverlay(LOverlay).Character.Text := AItem.Character;
      end;

    TGorillaDialogueItemKind.Answer:
      begin
        // answer items will automatically be created by the parent question
        // overlay component.
      end;

    TGorillaDialogueItemKind.Flow:
      begin
        LOverlay := TGorillaDialogueFlowOverlay.Create(Self);
        LOverlay.Parent := Self;
        LOverlay.Item := AItem;
        AItem.UIElement := LOverlay;
        LOverlay.Stored := false;
        // BUGFIX: because displayname is overwritten, the wrong character name is set
        TGorillaDialogueTextOverlay(LOverlay).Character.Text := AItem.Character;
      end;

    TGorillaDialogueItemKind.Reference:
      begin
        // do nothing
      end;

    else
      raise Exception.Create('undefined dialogue item kind');
  end;

  if ADoStartItem then
  begin
    AItem.Start();
  end;
end;

procedure TFixedDialogueHUD.DoOnStartDialogue(const ADialogue : TGorillaDialogue;
  const AItems : TArray<TGorillaDialogueItem>);
begin
  inherited;

  if Assigned(FStoredOnStartDialogue) then
    FStoredOnStartDialogue(ADialogue, AItems);
end;

procedure TFixedDialogueHUD.DoOnStopDialogue(const ADialogue : TGorillaDialogue);
begin
  inherited;

  if Assigned(FStoredOnStopDialogue) then
    FStoredOnStopDialogue(ADialogue);
end;

procedure TFixedDialogueHUD.StoreDialogueSystemEvents(ASystem : TGorillaDialogueSystem);
begin
  // Stored events from dialogue system to not delete those
  FStoredOnBeginDialogueItemEvent := ASystem.OnBeginDialogueItemEvent;
  FStoredOnEndDialogueItemEvent   := ASystem.OnEndDialogueItemEvent;

  FStoredOnBeginDialogueItem := ASystem.OnBeginDialogueItem;
  FStoredOnEndDialogueItem   := ASystem.OnEndDialogueItem;

  FStoredOnStartDialogue    := ASystem.OnStartDialogue;
  FStoredOnStopDialogue     := ASystem.OnStopDialogue;
  FStoredOnPauseDialogue    := ASystem.OnPauseDialogue;

  FStoredOnSkippedDialogue  := ASystem.OnSkippedDialogue;
  FStoredOnSkipAvailability := ASystem.OnSkipAvailability;

  FStoredOnBeginItemTimeout := ASystem.OnBeginItemTimeout;
  FStoredOnEndItemTimeout   := ASystem.OnEndItemTimeout;

  FStoredEvents := true;
end;

procedure TFixedDialogueHUD.RestoreDialogueSystemEvents(ASystem : TGorillaDialogueSystem);
begin
  if not FStoredEvents then
    Exit;

  // Stored events from dialogue system to not delete those
  ASystem.OnBeginDialogueItemEvent := FStoredOnBeginDialogueItemEvent;
  ASystem.OnEndDialogueItemEvent := FStoredOnEndDialogueItemEvent;

  ASystem.OnBeginDialogueItem := FStoredOnBeginDialogueItem;
  ASystem.OnEndDialogueItem := FStoredOnEndDialogueItem;

  ASystem.OnStartDialogue := FStoredOnStartDialogue;
  ASystem.OnStopDialogue  := FStoredOnStopDialogue;
  ASystem.OnPauseDialogue := FStoredOnPauseDialogue;

  ASystem.OnSkippedDialogue := FStoredOnSkippedDialogue;
  ASystem.OnSkipAvailability := FStoredOnSkipAvailability;

  ASystem.OnBeginItemTimeout := FStoredOnBeginItemTimeout;
  ASystem.OnEndItemTimeout := FStoredOnEndItemTimeout;

  // Unset to show they were not assigned yet
  FStoredOnBeginDialogueItemEvent := nil;
  FStoredOnEndDialogueItemEvent   := nil;

  FStoredOnBeginDialogueItem := nil;
  FStoredOnEndDialogueItem   := nil;

  FStoredOnStartDialogue    := nil;
  FStoredOnStopDialogue     := nil;
  FStoredOnPauseDialogue    := nil;

  FStoredOnSkippedDialogue  := nil;
  FStoredOnSkipAvailability := nil;

  FStoredOnBeginItemTimeout := nil;
  FStoredOnEndItemTimeout   := nil;

  FStoredEvents := false;
end;

procedure TFixedDialogueHUD.SetDialogue(const AValue : TGorillaDialogue);
begin
  // Restore events for previosly assigned dialogues
  if Assigned(FDialogue) then
    RestoreDialogueSystemEvents(FDialogue.DialogueSystem);

  if not Assigned(AValue) then
    Exit;

  // Before assigning the HUD events, we should store the original dialogue
  // system events in fields, for later restoring or calling
  StoreDialogueSystemEvents(AValue.DialogueSystem);

  inherited;
end;
{$ENDIF}












{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var LTP : TGorillaTriggerPoint;
begin
  // Deactivate clicking onto landscape model (we only track global screen clicks)
  Landscape.SetHitTestValue(false);
  // Set trees (Object_8, Object_9, Object_10, Object_11) sub-object to be transparent
  Landscape.Meshes[6].SetOpacityValue(0.997);
  Landscape.Meshes[7].SetOpacityValue(0.997);
  Landscape.Meshes[8].SetOpacityValue(0.997);
  Landscape.Meshes[9].SetOpacityValue(0.997);

  // By default, let's hide the tool tip rectangle
  HideToolTip();

  // Prepare game objects for mouse interaction
  Banana.TagString := 'Mhhh, a tasty banana!';
  Banana.SetHitTestValue(false);

  CoconutTree.TagString := 'A striking nut hangs from this coconut tree.';
  CoconutTree.SetHitTestValue(false);

  Coconut.TagString := 'The sacred coconut!';
  Coconut.SetHitTestValue(false);
  Coconut.SetVisibility(false);

  // Prepare audio files / music
  SetupAudio();

  // Start setting up pathfinding components
  SetupPathfinding();

  // Replace firemonkey material with some individual settings
  CreatePBRFiremonkey();

  // Activate global illumination (only on modern machines)
  GorillaViewport1.GlobalIllumDetail := 3;
  GorillaViewport1.GlobalIllumSoftness := 3;
  GorillaViewport1.ShadowStrength := 0.75;

  // Gimmick #1: We want the diamond to glow
  TGorillaDefaultMaterialSource(Landscape.Meshes[0].MaterialSource).EmissiveF :=
    TAlphaColorF.Create(0.145098, 0.588235, 0.745098, 1);
  GorillaViewport1.EmissiveBlur := 2;

  // Gimmick #2: We want the diamond to bounce
  FloatAnimation1.Parent := Landscape.Meshes[0];
  FloatAnimation1.Enabled := true;
  FloatAnimation1.Start;

  // Create a dialogue HUD for the conversation
  FHUD := TFixedDialogueHUD.Create(Self);
  FHUD.Parent := GorillaViewport1;
  FHUD.Align := TAlignLayout.Client;
  FHUD.Viewport := GorillaViewport1;
  FHUD.AudioManager := Self.GorillaFMODAudioManager1;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // Let's modify the material shader on the landscape model
  // If the camera is close to a fragment let's make it transparent
  AddDepthTransparency();
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // On closing the applicatin, we need to stop FMOD sounds
  GorillaFMODAudioManager1.StopAllChannels;

  // Afterwards we need to clear the interfaces, otherwise access violations
  // may occur, due to auto-clearing of underlying FMOD instances, which
  // FMOD interfaces need.
  FMusic := nil;
  FMusicChannel := nil;

  FSteps := nil;
  FStepsChannel := nil;

  FThrow := nil;
  FPlop := nil;
  FCollect := nil;
  FThrowChannel := nil;
end;

procedure TForm1.CreatePBRFiremonkey();
begin
    // Finally, we replace original material source (also sub-meshes)
  // We DO NOT replace the texture in Monkey.Meshes[0].Meshes[1], because its
  // the eye-texture and do not need to glow
  Monkey.Meshes[0].MaterialSource := GlowingMonkeyMaterial;
  Monkey.Meshes[0].Meshes[0].MaterialSource := GlowingMonkeyMaterial;
end;

procedure TForm1.AddDepthTransparency();
var LTreeMesh : TGorillaMesh;
    LMat   : TGorillaDefaultMaterialSource;
    LShdr  : TStringList;
begin
  // To make the monkey character visible behind trees, we should render with
  // some transparency depending on the distance to the camera.
  // This is not the best solution, because the character position should be
  // reminded, but we don't have that information in our landscape shaders.
  LShdr := TStringList.Create();
  LShdr.Text :=
    'void SurfaceShader(inout TLocals DATA){'#13#10 +
    '  float l_Dist = distance(_EyePos.xyz, DATA.TransfVertPos.xyz);'#13#10 +
    '  l_Dist = abs(l_Dist);'#13#10 +
    '  DATA.Alpha = min((l_Dist / 10.0) * 0.5, 1.0);'#13#10 +
    '  DATA.BaseColor.a = DATA.Alpha;'#13#10 +
    '}'#13#10;

  // "Object_8", "Object_9", "Object_10" + "Object_11" are the meshes of the trees
  // We update their shaders manually here
  LTreeMesh := Landscape.Meshes[6];
  LMat   := LTreeMesh.MaterialSource as TGorillaDefaultMaterialSource;
  LMat.SurfaceShader := LShdr;

  LTreeMesh := Landscape.Meshes[7];
  LMat   := LTreeMesh.MaterialSource as TGorillaDefaultMaterialSource;
  LMat.SurfaceShader := LShdr;

  LTreeMesh := Landscape.Meshes[8];
  LMat   := LTreeMesh.MaterialSource as TGorillaDefaultMaterialSource;
  LMat.SurfaceShader := LShdr;

  LTreeMesh := Landscape.Meshes[9];
  LMat   := LTreeMesh.MaterialSource as TGorillaDefaultMaterialSource;
  LMat.SurfaceShader := LShdr;
end;

procedure TForm1.SetupAudio();
var LPath : String;
begin
{$IFDEF MSWINDOWS}
  LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    IncludeTrailingPathDelimiter('assets');
{$ELSE}
  LPath := IncludeTrailingPathDelimiter(TPath.GetHomePath()) +
    IncludeTrailingPathDelimiter('assets');
{$ENDIF}

  // load music
  FMusic := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'jew-13506.mp3');
  FMusic.Mode := FMOD_LOOP_NORMAL; // loop the music
  FMusicChannel := GorillaFMODAudioManager1.AddChannelGroup('Music');
  FMusicChannel.Volume := 0.5;
  GorillaFMODAudioManager1.PlaySound(FMusic, FMusicChannel);

  // load foot steps sample
  FSteps := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '167157__kmoon__footsteps_grass.ogg');
  FSteps.Mode := FMOD_LOOP_NORMAL; // loop the steps
  FStepsChannel := GorillaFMODAudioManager1.AddChannelGroup('Steps');

  // load throwing sound sample
  FThrow := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '443617__hachiman935__objeto_lanzado_01.ogg');
  FThrowChannel := GorillaFMODAudioManager1.AddChannelGroup('Throw');
  FThrowChannel.Volume := FThrowChannel.Volume * 2;

  // load plop sample
  FPlop := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '447910__breviceps__plop.wav');

  // load collect sample
  FCollect := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '499790__robinhood76__08470-music-box-collect-ding.wav');

  // load all dialogue samples (starts at index #5)
  LPath := LPath + IncludeTrailingPathDelimiter('dialogues');
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-01.wav');    // index=5
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-02.wav');    // index=6
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-03.wav');    // index=7
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-04.wav');    // index=8
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-05-01.wav'); // index=9
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-05-02.wav'); // index=10
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-05-03.wav'); // index=11
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-06-01.wav'); // index=12
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-06-02.wav'); // index=13
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D1-06-03.wav'); // index=14

  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D2-01.wav');    // index=15
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D2-02.wav');    // index=16

  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D3-01.wav');    // index=17
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D4-01.wav');    // index=18
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D5-01.wav');    // index=19
  GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'D6-01.wav');    // index=20
end;

procedure TForm1.SetupPathfinding();
var LGridSize : TPoint;
    LSize3D : TPointF;
begin
  // 1) Setup the PathFinder
  // Create the background component for path finding
  FPathFinder := TGorillaPathfindingAStar.Create(nil);
  FPathFinder.ObstacleMargin := Point3D(0.5, 0.5, 0.5);

  // Link monkey group as agent to the path finder component
  FPathFinder.Agent := MonkeyNavigator;

  // Add all alpha walls as obstacles to the map
  FPathFinder.AddObstacle(AlphaWall1, true);
  FPathFinder.AddObstacle(AlphaWall2, true);
  FPathFinder.AddObstacle(AlphaWall3, true);
  FPathFinder.AddObstacle(AlphaWall4, true);
  FPathFinder.AddObstacle(AlphaWall5, true);
  FPathFinder.AddObstacle(AlphaWall6, true);
  FPathFinder.AddObstacle(AlphaWall7, true);
  FPathFinder.AddObstacle(AlphaWall8, true);
  FPathFinder.AddObstacle(AlphaWall9, true);
  FPathFinder.AddObstacle(AlphaWall10, true);

  // Adding game objects in map
  FPathFinder.AddObstacle(Banana, true);
  FPathFinder.AddObstacle(CoconutTree, true);

  // Set dimensions of grid and used 3D space
  LGridSize := TPoint.Create(PATHFINDING_GRID_X, PATHFINDING_GRID_Z);
  FPathFinder.GridDimensions := LGridSize;

  LSize3D := TPointF.Create(PATHFINDING_3DSIZE_X, PATHFINDING_3DSIZE_Z);
  FPathFinder.Size3D := LSize3D;

  // Compute a path around all obstacles in given area
  FDestPoint := MonkeyNavigator.AbsolutePosition;
  FPathFinder.FindPath(MonkeyNavigator.AbsolutePosition, FDestPoint);

  // 2) Get the initial path for movement
  FPath := FPathFinder.ToNewPath3D(GorillaViewport1);
  FPath.Parent := GorillaViewport1;
  FPath.Visible := false; // not drawn

  // 3) Create a path animator
  FPathAnim := TGorillaPath3DAnimation.Create(MonkeyNavigator);

  // The path animation need to manipulate position of the agent
  FPathAnim.Parent := MonkeyNavigator;

  // It should take 5 seconds and move straight on the computed path
  FPathAnim.Duration   := FPath.Path.GetLength;
  FPathAnim.SplineType := TGorillaSpline3DType.Linear;

  // Register callback events
  FPathAnim.OnProcess  := DoOnPathAnimProcess;
  FPathAnim.OnFinish   := DoOnPathAnimFinished;

  // Apply the initial path to the path animator
  FPathAnim.Path := FPath.Path;

  // Make sure the agent is at same position as the pathfinder computed from
  MonkeyNavigator.Position.Point := FPathFinder.StartPosition;

  // Start movement on path once
  FPathAnim.Enabled := true;
  FPathAnim.Start();
end;

function TForm1.GetYAngleBetweenPoints(A, B : TPoint3D) : Single;
var dx, dz : Single;
begin
  dx := B.X - A.X;
  dz := A.Z - B.Z;
  Result := arctan2(dx, dz);
end;

procedure TForm1.DoOnPathAnimProcess(ASender : TObject);

  function GetKeyValues(APolygon : TGorillaPolygon3D; const T : Single;
  out P1, P2 : TPoint3D) : Single;
  var LDeltaPos : Single;
      LSglEnt : Integer;
  begin
    if System.Length(APolygon) <= 0 then
    begin
      P1 := TPoint3D.Zero;
      P2 := TPoint3D.Zero;
      Result := 0;

      Exit;
    end;

    // get current key position
    LDeltaPos := T * High(APolygon);
    // key value
    LSglEnt := Floor(LDeltaPos);
    // key offset
    Result := LDeltaPos - LSglEnt;

    // key coordinate
    if (LSglEnt <= High(APolygon)) then
      P1 := APolygon[LSglEnt]
    else
      P1 := APolygon[High(APolygon)];

    inc(LSglEnt);
    if (LSglEnt <= High(APolygon)) then
      P2 := APolygon[LSglEnt]
    else
      P2 := APolygon[High(APolygon)];
  end;

var LAngleY : Single;
    P1, P2  : TPoint3D;
begin
  // Get the currently relevant point to compute rotation
  GetKeyValues(FPolygon, FPathAnim.NormalizedTime, P1, P2);

  // Adjust rotation of our monkey
  LAngleY := GetYAngleBetweenPoints(P1, P2);
  Monkey.RotationAngle.Y := RadToDeg(LAngleY);

  // Play run forward animation
  Monkey.AnimationManager.PlayAnimation('firemonkey-run-forward.fbx');

  // Play walking sound if not already playing
  if not FStepsChannel.IsPlaying then
    GorillaFMODAudioManager1.PlaySound(FSteps, FStepsChannel);
end;

procedure TForm1.DoOnPathAnimFinished(ASender : TObject);
var LTP : TGorillaTriggerPoint;
    LDist : Single;
    LAgentPos,
    LViewDir : TPoint3D;
begin
  // Play idle animation of the monkey
  Monkey.AnimationManager.PlayAnimation('mixamo.com');

  // Stop walking sound from playing
  FStepsChannel.Stop();

  // Check trigger points manually on finishing path walking
  LAgentPos := MonkeyNavigator.AbsolutePosition;
  GorillaTriggerPointManager1.ClosestTriggerPoint(LAgentPos, Point3D(0, 0, 1),
    LTP, LDist);
end;

procedure TForm1.UpdatePathfinding();
begin
  // New computation of path
  FPathFinder.FindPath(MonkeyNavigator.AbsolutePosition, FDestPoint);

  // Stop the current animation
  FPathAnim.Stop();
  FPathAnim.Enabled := false;

  // Apply computed path data to our existing TGorillaPath3D instance, instead for recreating each time
  FPathFinder.ApplyToPath3D(FPath);

  // Reset the used path data in our path animation
  FPathAnim.Duration := FPath.Path.GetLength;
  FPathAnim.Path := FPath.Path;

  // For correct rotation of our character, we need the polygon to detect the
  // next node to adjust to
  FPath.Path.FlattenToPolygon(FPolygon);

  // Restart movement on path
  FPathAnim.Enabled := true;
  FPathAnim.Start();
end;

procedure TForm1.ShowSacredCoconut();
begin
  FPathFinder.AddObstacle(Coconut, true);

  CoconutAnim.Enabled := true;
  Coconut.SetVisibility(true);

  // Play the plop sound sample
  GorillaFMODAudioManager1.PlaySound(FThrow, FThrowChannel);
end;

procedure TForm1.ShowToolTip(AText : String; X, Y: Single);
begin
  // Show up the tool tip at the current screen position
  ToolTipRect.Position.Point := PointF(X, Y) + PointF(8, -32);
  ToolTipText.Text := AText;
  ToolTipRect.Visible := true;
end;

procedure TForm1.HideToolTip();
begin
  // Hide the tool tip
  ToolTipRect.Visible := false;
end;

function TForm1.PerformGameObjectToolTip(AObj : TControl3D; AGlobalBounds : Boolean;
  AScreenPos : TPoint3D; ARayStart : TPoint3D; X, Y : Single) : Boolean;
var LRayDir : TPoint3D;
    LHitPosFar,
    LHitPos : TPoint3D;
    LHit    : Boolean;
    LBBox   : TBoundingBox;
begin
  if not AObj.Visible then
    Exit(false);

  LRayDir := (AScreenPos - ARayStart).Normalize();
  if AObj is TGorillaModel then
  begin
    // For model gameobjects is much faster to do a bounding box intersection
    // test than a triangle test!
    if AGlobalBounds then LBBox := AObj.GlobalBounds
                     else LBBox := TGorillaModel(AObj).GetAbsoluteBoundingBox();
    LHit := FMX.Types3D.RayCastCuboidIntersect(ARayStart, LRayDir, LBBox.CenterPoint,
      LBBox.Width, LBBox.Height, LBBox.Depth, LHitPos, LHitPosFar) > 0;
  end
  else LHit := AObj.RayCastIntersect(ARayStart, LRayDir, LHitPos);

  if LHit then
  begin
    // only show tooltip when you're nearby
    if LHitPos.Distance(MonkeyNavigator.AbsolutePosition) < TOOLTIP_DISTANCE then
    begin
      ShowToolTip(AObj.TagString, X, Y);
      Result := true;
      Exit;
    end;
  end;

  Result := false;
end;

function TForm1.PerformGameObjectToolTips(AScreenPos : TPoint3D; ARayStart : TPoint3D;
  X, Y : Single) : Boolean;
begin
  // Banana
  Result := PerformGameObjectToolTip(Banana, false, AScreenPos, ARayStart,
    X, Y);

  if Result then
    Exit;

  // Coconut Tree
  Result := PerformGameObjectToolTip(CoconutTree, true, AScreenPos, ARayStart,
    X, Y);

  if Result then
    Exit;

  // Coconut
  Result := PerformGameObjectToolTip(Coconut, false, AScreenPos, ARayStart,
    X, Y);

  if Result then
    Exit;
end;

function TForm1.PerformGameObjectClick(AObj : TControl3D; AGlobalBounds : Boolean;
  AScreenPos : TPoint3D; ARayStart : TPoint3D; X, Y : Single;
  AAction : TAction) : Boolean;
var LRayDir : TPoint3D;
    LHitPosFar,
    LHitPos : TPoint3D;
    LBBox   : TBoundingBox;
begin
  if not AObj.Visible then
    Exit(false);

  LRayDir := (AScreenPos - ARayStart).Normalize();
  if AObj is TGorillaModel then
  begin
    // For model gameobjects is much faster to do a bounding box intersection
    // test than a triangle test!
    if AGlobalBounds then LBBox := AObj.GlobalBounds
                     else LBBox := TGorillaModel(AObj).GetAbsoluteBoundingBox();
    Result := FMX.Types3D.RayCastCuboidIntersect(ARayStart, LRayDir, LBBox.CenterPoint,
      LBBox.Width, LBBox.Height, LBBox.Depth, LHitPos, LHitPosFar) > 0;
  end
  else Result := AObj.RayCastIntersect(ARayStart, LRayDir, LHitPos);

  if Result then
  begin
    // Is it close enough
    if LHitPos.Distance(MonkeyNavigator.AbsolutePosition) <= CLICK_DISTANCE then
    begin
      // Start action ...
      if Assigned(AAction) then
        AAction.Execute();
    end;
  end;
end;

function TForm1.PerformGameObjectClicks(AScreenPos : TPoint3D; ARayStart : TPoint3D;
  X, Y : Single) : Boolean;
begin
  // Banana
  Result := PerformGameObjectClick(Banana, false, AScreenPos, ARayStart,
    X, Y, Self.CollectBananaAction);

  if Result then
    Exit;

  // CoconutTree
  Result := PerformGameObjectClick(CoconutTree, true, AScreenPos, ARayStart,
    X, Y, Self.ShakeTheTreeAction);

  if Result then
    Exit;

  // Coconut
  Result := PerformGameObjectClick(Coconut, false, AScreenPos, ARayStart,
    X, Y, Self.CollectCoconutAction);

  if Result then
    Exit;
end;

procedure TForm1.GorillaDialogueSystem1StopDialogue(
  const ADialogue: TGorillaDialogue);
begin
  if ADialogue.Ident = 'Dialogue1' then
  begin
    // Reactivate the Banana and reset game to starting mode, for repeating
    // the process
    Banana.SetVisibility(true);
    FCoconutFound := false;
    FBananaUnlocked := false;
  end;
end;

procedure TForm1.GorillaTriggerPointManager1Items0Triggered(
  ASender: TGorillaTriggerPointManager; const APos, AViewDir: TPoint3D;
  const APoint: TGorillaTriggerPoint; const ADistance: Single);
begin
  // If a nearby trigger point was detected and its close enough
  if (ADistance < APoint.Distance) then
  begin
    // If the sacred coconut was not found, play Dialogue2
    if FCoconutFound then
    begin
      // Remove the sacred coconut from our inventory
      GorillaInventory1.DropCollectedItem('Coconut', true);

      // Activate the main dialog
      FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue1');
    end
    else
    begin
      // Otherwise start Dialogue1
      FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue2');
    end;

    // Start if it was not already started (happens when moving on, while the dialogue)
    if Assigned(FHUD.Dialogue) and (not FHUD.Dialogue.Started) then
      FHUD.Start();
  end;
end;

procedure TForm1.GorillaViewport1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
var LScreenPos : TPoint3D;
    LRayPos    : TPoint3D;
    LMousePos  : TPointF;
begin
  HideToolTip();

  // Get 3D coordinates from screen coordinates
  LMousePos := PointF(X, Y);
  LScreenPos := GorillaViewport1.ScreenToWorld(LMousePos);

  // Get the current camera position as start for raycasting
  LRayPos := GorillaCamera1.AbsolutePosition;

  // Perform a check on each game object able to show a tooltip
  PerformGameObjectToolTips(LScreenPos, LRayPos, X, Y);
end;

procedure TForm1.GorillaViewport1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var LRayPos,
    LRayDir : TVector3D;
    LHitPos,
    LNormal,
    LScreenPos : TPoint3D;
    LClickPos  : TPointF;
begin
  // 1) Get 3D position of click, by converting screen coordinates into 3D coordinates
  LClickPos := PointF(X, Y);
  LScreenPos := GorillaViewport1.ScreenToWorld(LClickPos);

  // 2) Cast a ray from camera to the clicking position, to retrieve the real
  //    3D destination coordinate
  LRayPos := GorillaCamera1.AbsolutePosition;

  // 3) Check if GameObjects were clicked
  if PerformGameObjectClicks(LScreenPos, LRayPos, X, Y) then
  begin
    // A game object was clicked
  end
  else
  begin
    // No click, start pathfinding navigation
    LClickPos := GorillaViewport1.ScreenToLocal(LClickPos);

    LRayDir := (LScreenPos - LRayPos).Normalize();
    if GorillaPlane1.RayCastIntersect(LRayPos, LRayDir, LHitPos, LNormal) then
    begin
      // Bugfix: We need to flip z-axis projection for correct 2D-pathfinding coordinate translation
      LHitPos := LHitPos * TMatrix3D.CreateScaling(Point3D(1, 1, -1));

      // If raycasting was successfull - we can start updating the path
      FDestPoint := LHitPos;
      FDestPoint.Y := 0;
      UpdatePathfinding();
    end;
  end;
end;

procedure TForm1.CoconutAnimFinish(Sender: TObject);
begin
  // Let's switch to idle animation again
  Monkey.AnimationManager.PlayAnimation('mixamo.com');

  // Stop throwing sound from playing
  FStepsChannel.Stop();

  // Show some dialogue about the result of the action
  FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue4');
  if Assigned(FHUD.Dialogue) and (not FHUD.Dialogue.Started) then
    FHUD.Start();

  // Play the plop sound sample of the coconut
  GorillaFMODAudioManager1.PlaySound(FPlop, FThrowChannel);
end;

procedure TForm1.CollectBananaActionExecute(Sender: TObject);
begin
  if not FBananaUnlocked then
  begin
    // Not able to collect the Banana yet!
    FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue6');
    if Assigned(FHUD.Dialogue) and (not FHUD.Dialogue.Started) then
      FHUD.Start();
    Exit;
  end;

  // Collect the banana
  FPathFinder.RemoveObstacle(Banana);
  Banana.SetVisibility(false);

  // Add banana to inventory
  GorillaInventory1.Collect('Banana');

  // Play collect sound sample
  GorillaFMODAudioManager1.PlaySound(FCollect, FThrowChannel);
end;

procedure TForm1.ShakeTheTreeActionExecute(Sender: TObject);
var LItems  : TArray<TGorillaInventoryCollectable>;
    LAngleY : Single;
begin
  if Coconut.Visible or Self.FCoconutFound then
  begin
    // If we already hit the sacred coconut and it fell off, we should show
    // some kind of dialogue
    FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue5');
    if Assigned(FHUD.Dialogue) and (not FHUD.Dialogue.Started) then
      FHUD.Start();
    Exit;
  end;

  // Shake the tree, if banana was found
  LItems := GorillaInventory1.FindCollectedItems('Banana');
  if System.Length(LItems) <= 0 then
  begin
    // Banana not collect yet !
    FBananaUnlocked := true;
    FHUD.Dialogue := GorillaDialogueSystem1.FindDialogue('Dialogue3');
    if Assigned(FHUD.Dialogue) and (not FHUD.Dialogue.Started) then
      FHUD.Start();
    Exit;
  end;

  // Banana was thrown at the tree, remove it from our inventory
  GorillaInventory1.DropCollectedItem('Banana', true);

  // Adjust rotation of the monkey to the tree
  LAngleY := GetYAngleBetweenPoints(MonkeyNavigator.AbsolutePosition,
    CoconutTree.AbsolutePosition);
  Monkey.RotationAngle.Y := RadToDeg(LAngleY);

  // Start throwing animation of the firemonkey
  Monkey.AnimationManager.PlayAnimation('firemonkey-throw.fbx');

  // Show the sacred coconut and run the animation
  ShowSacredCoconut();
end;

procedure TForm1.CollectCoconutActionExecute(Sender: TObject);
begin
  // Collect the sacred coconut, but only if it's visible
  if not Coconut.Visible then
    Exit;

  GorillaInventory1.Collect('Coconut');
  Coconut.SetVisibility(false);

  // Mark: Coconut was collect and can be used with the diamond
  Self.FCoconutFound := true;

  // Play collect sound sample
  GorillaFMODAudioManager1.PlaySound(FCollect, FThrowChannel);
end;

end.
