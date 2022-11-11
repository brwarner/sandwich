import InkStory from "./story";
import $ from "jquery";

function formatValue(val) { 
    if(typeof val == "number" && val > 0) { 
        return "+" + val;
    }
    return val;
}

function getStoryValueFromElement(element: JQuery<HTMLElement>): number|boolean|string|null {
    const dataVariable = element.attr("data-variable");
    if(dataVariable) { 
        return formatValue(InkStory.variablesState[dataVariable]);
    }

    const dataFunction = element.attr("data-function");
    if(dataFunction) { 
        const result = InkStory.EvaluateFunction(dataFunction, undefined, true) as { returned: any, output: string };
        return result.output.trim();
    }

    return null;
}

// Updates the contents of an element based on story state
function UpdateStoryElement(element: JQuery<HTMLElement>) { 
    // Get value for this element
    let value = getStoryValueFromElement(element);
    if(value === null) { return; }

    if(element.attr("data-text") !== undefined) { 
        const html = value.toString();
        element.html(html);
        if(element.text().trim() === "") { 
            element.addClass("empty");
        } else { 
            element.removeClass("empty");
        }
    }
    if(element.attr("data-src") !== undefined) { 
        element.attr("src", value.toString());
    }
    const dataClass = element.attr("data-class");
    if(dataClass !== undefined) {
        if(dataClass === "")
        {
            element.removeClass();
            element.addClass(value.toString());
        }
        else
        {
            if(value) { 
                element.addClass(dataClass);
            } else { 
                element.removeClass(dataClass);
            }
        }
    }
}

export function UpdateStoryElements() { 
    $("[data-story-binding]").each(function() { 
        UpdateStoryElement($(this))
    });
}
