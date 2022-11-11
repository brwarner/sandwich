import { Choice } from "inkjs/engine/Choice";
import { UpdateStoryElements } from "./binding";
import { clearFeed, showTitle } from "./feed";
import { addChoiceToFeed, addParagraphToFeed } from "./gameFeed";
import { AddSaveData, Autosave, GetAutosave, GetSaveData, SaveEntry } from "./save";
import InkStory from "./story";
import { parseTag } from "./tags";

var savePoint: string|null = null;

export function gameContinue()
{
    // Set initial save point
    if(savePoint == null) { 
        savePoint = InkStory.state.toJson();
    }

    // Generate story text - loop through available content
    while(InkStory.canContinue) {
        // Get ink to generate the next paragraph
        var paragraphText = InkStory.Continue();
        if(paragraphText == null) { 
            continue;
        }

        /*// Get tags
        var tags = InkStory.currentTags ?? [];

        // Any special tags included with this line
        var customClasses: string[] = [];
        for(var i=0; i<tags.length; i++) {
            var tag = tags[i];

            // Detect tags of the form "X: Y". Currently used for IMAGE and CLASS but could be
            // customised to be used for other things too.
            var splitTag = splitPropertyTag(tag);

            // AUDIO: src
            if( splitTag && splitTag.property == "AUDIO" ) {
              if('audio' in this) {
                this.audio.pause();
                this.audio.removeAttribute('src');
                this.audio.load();
              }
              this.audio = new Audio(splitTag.val);
              this.audio.play();
            }

            // AUDIOLOOP: src
            else if( splitTag && splitTag.property == "AUDIOLOOP" ) {
              if('audioLoop' in this) {
                this.audioLoop.pause();
                this.audioLoop.removeAttribute('src');
                this.audioLoop.load();
              }
              this.audioLoop = new Audio(splitTag.val);
              this.audioLoop.play();
              this.audioLoop.loop = true;
            }

            // IMAGE: src
            if( splitTag && splitTag.property == "IMAGE" ) {
                var imageElement = document.createElement('img');
                imageElement.src = splitTag.val;

                addToFeed(imageElement);
            }

            // LINK: url
            else if( splitTag && splitTag.property == "LINK" ) {
                window.location.href = splitTag.val;
            }

            // LINKOPEN: url
            else if( splitTag && splitTag.property == "LINKOPEN" ) {
                window.open(splitTag.val);
            }

            // BACKGROUND: src
            else if( splitTag && splitTag.property == "BACKGROUND" ) {
                feedBackground(`url('${splitTag.val}')`)
            }

            // CLASS: className
            else if( splitTag && splitTag.property == "CLASS" ) {
                customClasses.push(splitTag.val);
            }

            // CLEAR - removes all existing content.
            // RESTART - clears everything and restarts the story from the beginning
            else if( tag == "CLEAR" || tag == "RESTART" ) {
                if( tag == "RESTART" ) {
                    restart();
                    return;
                }
            }
        }*/

        // Add paragraph to feed
        addParagraphToFeed(paragraphText, InkStory.currentTags ?? []);
    }

    clearFeed(".choice");

    // Create HTML choices from ink choices
    InkStory.currentChoices.forEach((choice) => {
        addChoiceToFeed(choice, handleChoiceClicked);
    });

    UpdateStoryElements();
}

export function gameStart()
{
    gameContinue();
}

export function gameReset()
{
    clearFeed();
    showTitle();

    savePoint = null;
    InkStory.ResetState();

    gameContinue();
}

export function gameSave()
{
    if(savePoint == null) {
        return;
    }

    AddSaveData(savePoint);
}

export function gameHasSave()
{
    return window.localStorage.getItem('save-state') !== null;
}

export function gameTryLoadAutosave()
{
    const autosave = GetAutosave();
    loadState(autosave);
}

export function gameLoad(entry: SaveEntry)
{
    const savedState = GetSaveData(entry);
    loadState(savedState);
}

export function getGameTags(): [string, string][]
{
    return (InkStory.globalTags ?? []).filter(tag => tag !== null).map(tag => parseTag(tag));
}

function loadState(state: string|null)
{
    if(state === null) {
        return;
    }

    // Clear feed
    clearFeed();

    // Load data
    try {
        InkStory.state.LoadJson(state);
    } catch (e) {
        console.debug("Couldn't load save state");
    }

    // Run story
    gameContinue();
}

function handleChoiceClicked(choice: Choice)
{
    // Tell the story where to go next
    InkStory.ChooseChoiceIndex(choice.index);

    // This is where the save button will save from
    savePoint = InkStory.state.toJson();
    Autosave(savePoint);

    // Aaand loop
    gameContinue();
}