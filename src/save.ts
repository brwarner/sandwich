import { v4 as uuid } from "uuid";
import InkStory from "./story";

/** Description of a save game entry stored elsewhere in local storage */
export interface SaveEntry
{
    UserName: string;
    GameDescription: string;
    StorageKey: string;
    Time: number;
}

export type SaveInventory = SaveEntry[];
const InventoryKey = "save-inventory";
const AUTOSAVE_KEY = "autosave";

/**
 * Gets an inventory of all saves with metadata
 * @returns List of save entries
 */
export function GetSaveInventory(): SaveInventory
{
    const store = localStorage.getItem(InventoryKey);
    if(store == null) { 
        return [];
    }

    return JSON.parse(store) as SaveInventory;
}

/**
 * Checks if the save inventory has any saves
 */
export function HasSaves(): boolean
{
    return GetSaveInventory().length > 0;
}

/**
 * Gets the save data from a given save
 * @param entry Save game entry from GetSaveInventory
 * @returns Data (or null if can't load)
 */
export function GetSaveData(entry: SaveEntry): string|null
{
    return localStorage.getItem(entry.StorageKey);
}

/**
 * Saves a state to autosave
 * @param data Save state stringified
 */
export function Autosave(data: string): void
{
    localStorage.setItem(AUTOSAVE_KEY, data);
}

/**
 * Loads autosave data, if any
 * @returns Autosave data or null if empty
 */
export function GetAutosave(): string|null
{
    return localStorage.getItem(AUTOSAVE_KEY);
}

/**
 * Add a new save to the inventory
 * @param data Save data stringified
 */
export function AddSaveData(data: string): void
{
    // Get save inventory
    var inventory = GetSaveInventory();

    // Get game description
    const description = getGameStateDescription();
    const name = prompt("Enter a name for the save: \"" + description.trim() + "\"");
    if(name === null) {
        return;
    }

    // Create new entry
    const entry: SaveEntry = {
        UserName: name,
        GameDescription: description,
        StorageKey: "save_" + uuid(),
        Time: new Date().getDate()
    }

    // Add to inventory
    inventory.push(entry);

    // Save game
    localStorage.setItem(entry.StorageKey, data);
    localStorage.setItem(InventoryKey, JSON.stringify(inventory));
}

/**
 * Deletes a save game
 * @param entry Entry to delete from GetSaveInventory
 */
export function DeleteSave(entry: SaveEntry)
{
    // Get inventory
    let inventory = GetSaveInventory();

    // Remove entry
    inventory = inventory.filter(x => x.StorageKey !== entry.StorageKey);
    
    // Delete save and re-save inventory
    localStorage.removeItem(entry.StorageKey);
    localStorage.setItem(InventoryKey, JSON.stringify(inventory));
}

export function getGameStateDescription()
{
    var result = InkStory.EvaluateFunction("describe_game_state", undefined, true) as { returned: any, output: string };
    return result.output;
}