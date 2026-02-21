export interface HeroAttributes {
  hp: number; // 0: Health Points
  hpRegen: number; // 1: Health Regeneration
  ad: number; // 2: Attack Damage
  ap: number; // 3: Ability Power
  attackSpeed: number; // 4: Attack Speed
  crit: number; // 5: Critical Strike Chance
  armor: number; // 6: Armor (Physical Resistance)
  mr: number; // 7: Magic Resistance
  cdr: number; // 8: Cooldown Reduction
  moveSpeed: number; // 9: Movement Speed
  // Future attributes (when contract is updated):
  lifesteal?: number; // 10: Lifesteal
  tenacity?: number; // 11: Tenacity
  penetration?: number; // 12: Penetration
  mana?: number; // 13: Mana
  manaRegen?: number; // 14: Mana Regeneration
  intelligence?: number; // 15: Intelligence
}

export interface Hero {
  tokenBoundAccount: string;
  lastForgeTime: number;
  totalForges: number;
  mintTime: number;
  classId: number;
  stage: number;
  attributes: HeroAttributes;
}

export enum HeroClass {
  Warrior = 0,
  Mage = 1,
  Archer = 2,
  Rogue = 3,
  Paladin = 4,
  Summoner = 5,
  Berserker = 6,
  Priest = 7,
}

export enum HeroStage {
  Forging = 0,
  Completed = 1,
  SoloLeveling = 2,
}
