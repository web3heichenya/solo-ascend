import { HeroClass } from '@/types';

export interface ClassAttributes {
  hp: number;
  hpRegen: number;
  ad: number;
  ap: number;
  attackSpeed: number;
  crit: number;
  armor: number;
  mr: number;
  cdr: number;
  moveSpeed: number;
  lifesteal: number;
  tenacity: number;
  penetration: number;
  manaRegen: number;
  intelligence: number;
  mana: number;
}

export const DEFAULT_CLASS_ATTRIBUTES: Record<HeroClass, ClassAttributes> = {
  [HeroClass.Warrior]: {
    hp: 1200,
    hpRegen: 15,
    ad: 90,
    ap: 40,
    attackSpeed: 110,
    crit: 80,
    armor: 150,
    mr: 120,
    cdr: 100,
    moveSpeed: 110,
    lifesteal: 25,
    tenacity: 140,
    penetration: 70,
    manaRegen: 40,
    intelligence: 60,
    mana: 200,
  },
  [HeroClass.Mage]: {
    hp: 700,
    hpRegen: 10,
    ad: 45,
    ap: 150,
    attackSpeed: 90,
    crit: 40,
    armor: 50,
    mr: 80,
    cdr: 150,
    moveSpeed: 100,
    lifesteal: 10,
    tenacity: 70,
    penetration: 90,
    manaRegen: 150,
    intelligence: 150,
    mana: 400,
  },
  [HeroClass.Archer]: {
    hp: 800,
    hpRegen: 8,
    ad: 120,
    ap: 30,
    attackSpeed: 140,
    crit: 120,
    armor: 60,
    mr: 50,
    cdr: 80,
    moveSpeed: 130,
    lifesteal: 20,
    tenacity: 80,
    penetration: 130,
    manaRegen: 50,
    intelligence: 70,
    mana: 180,
  },
  [HeroClass.Rogue]: {
    hp: 900,
    hpRegen: 10,
    ad: 100,
    ap: 50,
    attackSpeed: 130,
    crit: 140,
    armor: 70,
    mr: 60,
    cdr: 90,
    moveSpeed: 140,
    lifesteal: 30,
    tenacity: 90,
    penetration: 140,
    manaRegen: 60,
    intelligence: 80,
    mana: 160,
  },
  [HeroClass.Paladin]: {
    hp: 1100,
    hpRegen: 18,
    ad: 80,
    ap: 100,
    attackSpeed: 95,
    crit: 60,
    armor: 120,
    mr: 140,
    cdr: 140,
    moveSpeed: 105,
    lifesteal: 20,
    tenacity: 150,
    penetration: 70,
    manaRegen: 120,
    intelligence: 110,
    mana: 300,
  },
  [HeroClass.Berserker]: {
    hp: 1150,
    hpRegen: 12,
    ad: 135,
    ap: 30,
    attackSpeed: 135,
    crit: 130,
    armor: 70,
    mr: 60,
    cdr: 80,
    moveSpeed: 120,
    lifesteal: 35,
    tenacity: 100,
    penetration: 120,
    manaRegen: 30,
    intelligence: 50,
    mana: 100,
  },
  [HeroClass.Summoner]: {
    hp: 850,
    hpRegen: 12,
    ad: 60,
    ap: 130,
    attackSpeed: 95,
    crit: 50,
    armor: 60,
    mr: 110,
    cdr: 140,
    moveSpeed: 110,
    lifesteal: 15,
    tenacity: 80,
    penetration: 90,
    manaRegen: 140,
    intelligence: 140,
    mana: 350,
  },
  [HeroClass.Priest]: {
    hp: 850,
    hpRegen: 20,
    ad: 40,
    ap: 130,
    attackSpeed: 90,
    crit: 50,
    armor: 60,
    mr: 150,
    cdr: 150,
    moveSpeed: 105,
    lifesteal: 10,
    tenacity: 110,
    penetration: 60,
    manaRegen: 160,
    intelligence: 140,
    mana: 400,
  },
};

export function getClassDefaultAttribute(
  classId: HeroClass,
  attribute: keyof ClassAttributes
): number {
  return DEFAULT_CLASS_ATTRIBUTES[classId]?.[attribute] ?? 0;
}

export function getAttributeDifference(
  classId: HeroClass,
  attribute: keyof ClassAttributes,
  currentValue: number
): number {
  const defaultValue = getClassDefaultAttribute(classId, attribute);
  return currentValue - defaultValue;
}
