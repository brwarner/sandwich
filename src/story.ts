import { Story } from "inkjs";
import StoryContent from "./story.json"

const InkStory = new Story(StoryContent);

InkStory.BindExternalFunction("is_browser", () => true, true);

export default InkStory;