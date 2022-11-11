import $ from "jquery";

// Root container for the story feed
const container = $("#feed .content");
const title = $("#title", container);
var scrollContainer = $('#feed');

// Delay between showing new feed items
const Delay = 200.0;

var currentDelay = 0;
var delayReset: NodeJS.Timeout|null = null;
var firstTime = true;
var previousBottomEdge = 0;

/**
 * Adds an element to the feed
 * @param element Element to add to the feed
 */
export function addToFeed(element: JQuery<HTMLElement>|HTMLElement)
{
    element = $(element);

    var bottomEdge = firstTime ? 0 : contentBottomEdgeY();

    // Hide and add to container
    element.addClass("hide").appendTo(container);

    // Create timeout
    setTimeout(() => $(element).removeClass("hide"), currentDelay);
    currentDelay += Delay;

    if(delayReset == null) {
        previousBottomEdge = bottomEdge;
        delayReset = setTimeout(updateFeed, 1);
    }
}

/**
 * Clears the feed
 * @param selector Optional selector to decide which elements to clear
 */
export function clearFeed(selector?: string)
{
    container.children(selector).not(title).remove();

    if(!selector) { 
        firstTime = true;
        scrollContainer.scrollTop(0);
        scrollContainer.scrollLeft(0);
    }
}

/**
 * Marks all elements in the feed as read
 */
export function markFeedAsRead()
{
    container.children().not(title).addClass("read");
}

/**
 * Shows or hide the title and byline in the feed
 * @param show Show or hide
 */
export function showTitle(show: boolean = true)
{
    if(show) { 
        title.removeClass("invisible");
    } else {
        title.addClass("invisible");
    }
}

/**
 * Sets the feed's background image
 * @param url CSS compatible background url
 */
export function feedBackground(url: string)
{
    scrollContainer.css("background", url);
}

// Called the frame after anything is added to the feed
function updateFeed()
{
    currentDelay = 0;
    delayReset = null;

    container.height(contentBottomEdgeY()+"px");

    if(!firstTime)
    {
        scrollDown(previousBottomEdge);
    }
    firstTime = false;
}

// The Y coordinate of the bottom end of all the story content, used
// for growing the container, and deciding how far to scroll.
function contentBottomEdgeY() {
    var bottomElement = container.children().last().get()[0];
    return bottomElement ? bottomElement.offsetTop + bottomElement.offsetHeight : 0;
}

// Scrolls the page down, but no further than the bottom edge of what you could
// see previously, so it doesn't go too far.
function scrollDown(previousBottomEdge) {

    // Line up top of screen with the bottom of where the previous content ended
    var target = previousBottomEdge;

    // Can't go further than the very bottom of the page
    var limit = (scrollContainer.prop("scrollHeight") ?? 0) - (scrollContainer.innerHeight() ?? 0);
    if( target > limit ) target = limit;

    var start = scrollContainer.scrollTop() ?? 0;

    var dist = target - start;
    scrollContainer.animate({ "scrollTop": target }, 300 + 300*dist/100);
}