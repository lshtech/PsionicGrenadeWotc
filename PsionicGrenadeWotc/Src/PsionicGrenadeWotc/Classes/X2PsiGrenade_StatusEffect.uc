// This is an Unreal Script
class X2PsiGrenade_StatusEffect extends X2StatusEffects config(PsiGrenade);

var config int PSIDISORIENTED_WILL_ADJUST;

var localized string PsiDisorientedFriendlyName;
var localized string PsiDisorientedLostFriendlyName;
var localized string PsiDisorientedFriendlyDesc;
var localized string PsiDisorientedEffectAcquiredString;
var localized string PsiDisorientedEffectTickedString;
var localized string PsiDisorientedEffectLostString;

static function X2Effect_PersistentStatChange PsiDisorientedStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f)
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Condition_UnitProperty			UnitPropCondition;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2Ability_PsiDisorientTemplate'.default.PsiDisorientedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(class'X2StatusEffects'.default.DISORIENTED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.PsiDisorientedFriendlyName, default.PsiDisorientedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'X2StatusEffects'.default.DISORIENTED_MOBILITY_ADJUST);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, class'X2StatusEffects'.default.DISORIENTED_AIM_ADJUST);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, default.PSIDISORIENTED_WILL_ADJUST);
	PersistentStatChangeEffect.VisualizationFn = PsiDisorientedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = PsiDisorientedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = PsiDisorientedVisualizationRemoved;
	PersistentStatChangeEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	PersistentStatChangeEffect.bIsImpairingMomentarily = true;
	PersistentStatChangeEffect.DamageTypes.AddItem('Mental');
	PersistentStatChangeEffect.EffectAddedFn = PsiDisorientedAdded;
	PersistentStatChangeEffect.DelayVisualizationSec = DelayVisualizationSec;

	if (default.DisorientedParticle_Name != "")
	{
		PersistentStatChangeEffect.VFXTemplateName = default.DisorientedParticle_Name;
		PersistentStatChangeEffect.VFXSocket = default.DisorientedSocket_Name;
		PersistentStatChangeEffect.VFXSocketsArrayName = default.DisorientedSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
	UnitPropCondition.ExcludeRobotic = true;
	UnitPropCondition.ExcludeDead = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

	return PersistentStatChangeEffect;
}

static function PsiDisorientedAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	//Being disoriented removes overwatch.
	if (XComGameState_Unit(kNewTargetState) != None)
	{
		XComGameState_Unit(kNewTargetState).ReserveActionPoints.Length = 0;
	}
		
}

static function PsiDisorientedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	if (EffectApplyResult != 'AA_Success')
	{
		return;
	}

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);

	if (UnitState != none && !UnitState.IsRobotic())
	{
		AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.PsiDisorientedFriendlyName, 'Confused', eColor_Purple, class'UIUtilities_Image'.const.UnitStatus_Disoriented);
		AddEffectMessageToTrack(BuildTrack, default.PsiDisorientedEffectAcquiredString, VisualizeGameState.GetContext(), default.PsiDisorientedFriendlyName, "img:///UILibrary_PerkIcons.UIPerk_disoriented", eUIState_Bad);
		UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
	}
}

static function PsiDisorientedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.PsiDisorientedFriendlyName, 'TurnWhileConfused', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Disoriented);
	AddEffectMessageToTrack(BuildTrack, default.PsiDisorientedEffectTickedString, VisualizeGameState.GetContext(), default.PsiDisorientedFriendlyName, "img:///UILibrary_PerkIcons.UIPerk_disoriented", eUIState_Bad);
	UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}

static function PsiDisorientedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if( !UnitState.IsAlive() )
	{
		return;
	}

	AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), default.PsiDisorientedLostFriendlyName, '', eColor_Good, class'UIUtilities_Image'.const.UnitStatus_Disoriented, 2.0f);
	AddEffectMessageToTrack(BuildTrack, default.PsiDisorientedEffectLostString, VisualizeGameState.GetContext(), default.PsiDisorientedFriendlyName, "img:///UILibrary_PerkIcons.UIPerk_disoriented", eUIState_Good);
	UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
}
