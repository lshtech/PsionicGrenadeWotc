class X2Item_PsiGrenade extends X2Item config(PsiGrenade);

var config WeaponDamageValue PSIGRENADEM1_BASEDAMAGE;
var config WeaponDamageValue PSIGRENADEM2_BASEDAMAGE;
var config WeaponDamageValue PSIGRENADEM3_BASEDAMAGE;

var config int PSIGRENADE_ISOUNDRANGE;
var config int PSIGRENADE_IENVIRONMENTDAMAGE;
var config int PSIGRENADE_IPOINTS;
var config int PSIGRENADE_ICLIPSIZE;
var config int PSIGRENADE_ISUPPLIES;
var config int PSIGRENADEM1_TRADINGPOSTVALUE;
var config int PSIGRENADEM2_TRADINGPOSTVALUE;
var config int PSIGRENADEM3_TRADINGPOSTVALUE;
var config int PSIGRENADEM1_RANGE;
var config int PSIGRENADEM1_RADIUS;
var config int PSIGRENADEM2_RANGE;
var config int PSIGRENADEM2_RADIUS;
var config int PSIGRENADEM3_RANGE;
var config int PSIGRENADEM3_RADIUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(CreatePsiGrenade());
	Grenades.AddItem(CreatePsiGrenadeMk2());
	Grenades.AddItem(CreatePsiGrenadeMk3());

	return Grenades;
}

static function X2DataTemplate CreatePsiGrenade()
{
	local X2GrenadeTemplate 			Template;
	local X2Effect_ApplyWeaponDamage 	WeaponDamageEffect;
	local X2Effect_Knockback 			KnockbackEffect;
	local ArtifactCost 					Resources;
	local X2Condition_UnitProperty		UnitCondition;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'PsiGrenade');
	Template.strImage = "img:///WP_Psi_Grenade.X2InventoryIcons.Inv_Psi_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	//Template.Requirements.RequiredSoldierClass = 'PsiOperative';
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.iRange = default.PSIGRENADEM1_RANGE;
	Template.iRadius = default.PSIGRENADEM1_RADIUS;

	Template.BaseDamage = default.PSIGRENADEM1_BASEDAMAGE;
	Template.iSoundRange = default.PSIGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PSIGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.PSIGRENADEM1_TRADINGPOSTVALUE;
	Template.PointsToComplete = default.PSIGRENADE_IPOINTS;
	Template.iClipSize = default.PSIGRENADE_ICLIPSIZE;
	Template.Tier = 1;
	Template.DamageTypeTemplateName = 'Psi';

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeTurret = true;

	// immediate damage
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitCondition);
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.ThrownGrenadeEffects.AddItem(class'X2PsiGrenade_StatusEffect'.static.PsiDisorientedStatusEffect());

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Psi_Grenade.WP_Grenade_Psi";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.PSIGRENADE_ISUPPLIES;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Template.UpgradeItem = 'PsiGrenadeMk2';

	Template.RewardDecks.AddItem('ExperimentalGrenadeRewards');

//	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, , default.PSIGRENADEM1_BASEDAMAGE.Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.PSIGRENADEM1_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.PSIGRENADEM1_RADIUS);
//	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, class'X2Ability_PsiGrenadeAbilities'.default.PSIGRENADEM1_WILL_BONUS);

	return Template;
}

static function X2DataTemplate CreatePsiGrenadeMk2()
{
	local X2GrenadeTemplate 			Template;
	local X2Effect_ApplyWeaponDamage 	WeaponDamageEffect;
	local X2Effect_Knockback 			KnockbackEffect;
	local ArtifactCost 					Resources;
	local X2Condition_UnitProperty		UnitCondition;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'PsiGrenadeMk2');
	Template.strImage = "img:///WP_Psi_Grenade.X2InventoryIcons.Inv_Psi_Bomb";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.iRange = default.PSIGRENADEM2_RANGE;
	Template.iRadius = default.PSIGRENADEM2_RADIUS;

	Template.BaseDamage = default.PSIGRENADEM2_BASEDAMAGE;
	Template.iSoundRange = default.PSIGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PSIGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.PSIGRENADEM2_TRADINGPOSTVALUE;
	Template.PointsToComplete = default.PSIGRENADE_IPOINTS;
	Template.iClipSize = default.PSIGRENADE_ICLIPSIZE;
	Template.Tier = 1;
	Template.DamageTypeTemplateName = 'Psi';

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeTurret = true;

	// immediate damage
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitCondition);
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.ThrownGrenadeEffects.AddItem(class'X2PsiGrenade_StatusEffect'.static.PsiDisorientedStatusEffect());

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Psi_Grenade.WP_Grenade_Psi";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.PSIGRENADE_ISUPPLIES;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
	Template.BaseItem = 'PsiGrenade'; // Which item this will be upgraded from
	
	Template.UpgradeItem = 'PsiGrenadeMk3'; 

//	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, , default.PSIGRENADEM2_BASEDAMAGE.Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.PSIGRENADEM2_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.PSIGRENADEM2_RADIUS);
//	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, class'X2Ability_PsiGrenadeAbilities'.default.PSIGRENADEM2_WILL_BONUS);

	return Template;
}

static function X2DataTemplate CreatePsiGrenadeMk3()
{
	local X2GrenadeTemplate 			Template;
	local X2Effect_ApplyWeaponDamage 	WeaponDamageEffect;
	local X2Effect_Knockback 			KnockbackEffect;
	local ArtifactCost 					Resources;
	local X2Condition_UnitProperty		UnitCondition;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'PsiGrenadeMk3');
	Template.strImage = "img:///WP_Psi_Grenade.X2InventoryIcons.Inv_Psi_Warhead";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.iRange = default.PSIGRENADEM3_RANGE;
	Template.iRadius = default.PSIGRENADEM3_RADIUS;

	Template.BaseDamage = default.PSIGRENADEM3_BASEDAMAGE;
	Template.iSoundRange = default.PSIGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PSIGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.PSIGRENADEM3_TRADINGPOSTVALUE;
	Template.PointsToComplete = default.PSIGRENADE_IPOINTS;
	Template.iClipSize = default.PSIGRENADE_ICLIPSIZE;
	Template.Tier = 1;
	Template.DamageTypeTemplateName = 'Psi';

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeTurret = true;
	
	// immediate damage
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitCondition);
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.ThrownGrenadeEffects.AddItem(class'X2PsiGrenade_StatusEffect'.static.PsiDisorientedStatusEffect());

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Psi_Grenade.WP_Grenade_Psi";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.PSIGRENADE_ISUPPLIES;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Template.CreatorTemplateName = 'SuperiorExplosives'; // The schematic which creates this item
	Template.BaseItem = 'PsiGrenadeMk2'; // Which item this will be upgraded from
	
//	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageLabel, , default.PSIGRENADEM2_BASEDAMAGE.Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.PSIGRENADEM3_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.PSIGRENADEM3_RADIUS);
//	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, class'X2Ability_PsiGrenadeAbilities'.default.PSIGRENADEM2_WILL_BONUS);

	return Template;
}