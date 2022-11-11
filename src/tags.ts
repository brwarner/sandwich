/**
 * Parses a tag into a key/value pair (or just key if no colon)
 * @param tag Tag to parse
 * @returns [key, value]
 */
export function parseTag(tag: string): [string, string]
{
    const parts = tag.split(":")
    if(parts.length == 2) { 
        return [parts[0].toLowerCase(), parts[1]];
    }

    return [tag.toLowerCase(), ""];
}