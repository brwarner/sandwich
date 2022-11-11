import { Choice } from "inkjs/engine/Choice";
import { addToFeed, clearFeed, markFeedAsRead, showTitle } from "./feed";
import $ from "jquery";
import "./game.scss";
import { marked } from "marked";
import { parseTag } from "./tags";

export function addChoiceToFeed(choice: Choice, callback: (choice: Choice) => void)
{
    // Create element to hold link
    var choiceElement = $("<p>").addClass("choice");

    // Create link
    var link = $("<a>").text(choice.text).appendTo(choiceElement);

    // Parse tags
    const tags = choice.tags ?? [];
    for(const tag of tags) { 
        const [type, value] = parseTag(tag);
        
        switch(type) { 
            case "class":
                choiceElement.addClass(value);
                break;

            case "image":
                link.append($("<img>").attr("src", value));
                choiceElement.addClass("inline");
                break;
        }
    }

    // Add to the feed
    addToFeed(choiceElement);

    // Create click listener
    link.on("click", (event) => { 
        // Don't follow link
        event.preventDefault();

        // Clear choices from feed
        clearFeed(".choice");

        // Mark all elements in the feed as read
        markFeedAsRead();

        // Run callback
        callback(choice);
    });
}

export function addParagraphToFeed(text: string, tags: string[])
{
    // Create element
    var p = $("<p>");
    
    // Parse text
    const parsed = marked.parseInline(text);
    p.html(parsed);

    // Style
    for(const tag of tags) { 
        const [type, value] = parseTag(tag);

        switch(type)
        {
            case "class":
                p.addClass(value);
                break;
            case "clear":
                clearFeed();
                showTitle(false);
                break;
        }
    }

    addToFeed(p)
}
