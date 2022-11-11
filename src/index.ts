// import "./style.css"
import "./layout.scss"
import { gameReset, gameStart, getGameTags } from "./game";
import $ from "jquery";

// Deal with global game tags
for(const [key, value] of getGameTags())
{
    if(key == "title") { 
        $("title,#title h1").text(value);
    } else if(key == "subtitle") {
        $("#subtitle").text(value);
    }
}

// Try to load autosave
// gameTryLoadAutosave();

// Setup buttons
$("#rewind").on("click", gameReset);

// Kick off the start of the story!
gameStart();