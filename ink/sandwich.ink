#title:Sandwich
#subtitle:by Brook Warner Jensen

// Fixed seed for testing
{not is_browser():
    ~ SEED_RANDOM(255)
}

At long last, you've arrived. 

* Earl's World Famous Deli
-

World famous. <i>World</i>. Famous. Deli.

You have spent the last sixteen of this planet's months observing its people from your covert 

You have spent the last sixteen of this world's months observing them from your covert reconnaissance craft in orbit. You've studied their language, culture, military tactics, and now, replete with the splendid and precise intelligence of their ways you have graduated to the next phase of your infiltration. 

Now, on the corner of a street so critical to their way of life they simply call it "Main", you are ready to order a sandwich.

* [You've trained for this.]

You have witnessed dozens--no, hundreds!--of sandwich orders thus far, carefully studying every minute detail of this oft-practiced but dignified ritual. What it's purpose is, you can't say, but it is your belief that what you order today will put every prior one to shame.

The line peels off, one human at a time, until you are face to face with the proprietor, a tall, lanky young creature whose awkward features remind you of one of your own.

His nametag reads: Fred, but you understand that by custom you should see and refer to him as a mere appendage of his master: Earl.

He looks up from the counter and nods.

-(intro)
* (nod_1) [Nod back.]You nod, curt and firm.
    He nods back.
    ->intro
* (nod_2) {nod_1} [Nod again.] You give him another nod.
    He looks around, clears his throat, and nods back. You can see it in his eyes, he knows now he is dealing with a champion of commerce.
    ->intro
* {nod_2} [Nod once more.] You nod once more, and it's as clean and practised as every nod you've given before.
    "Uh," he says, scratching his cheek. "Can I get you something, sir?"
    ->intro
* (vend) {not nod_2} "Vend me[."]," you bark.
    "Uh." He scratches his head. "What?"
    <-vent2
    <-intro
    ->DONE
    -- (vent2)
    ** {not nod_2 and vend} "Do you not vend here?"
    He looks around, as though searching for someone to confirm what he is hearing.
    Your talents of patronization are clearly too much for him.
    ->intro
* "One sandwich, if you please."
    There's no time to delay.
    {intro > 1: "Yeah..." He speaks nervously. "Okay..."}
    
-

He extracts from the toaster two slices of clean bread.

This is it.

->assemble

= assemble

LIST Ingredients = Bacon, Lettuce, Tomato, PeanutButter, Cheese, Eggs, Milk, Jam, Salami, Mayo, OrangeJuice, Nutella

VAR PeanutButterAndJam = (PeanutButter, Jam, Nutella)
VAR MeatSandwhich = (Eggs, Bacon, Salami, Lettuce, Tomato, Cheese, Mayo)
VAR IllegalIngredients = (Milk, OrangeJuice)

VAR offenses = 0

{&You want...|Next is...|Without a doubt, you need...}

- (go)

<-choose_ingredient_threads
+ "This sandwhich is complete!"[] you exclaim.
    ->try_complete

= check_sandwhich_sanity(newItem)
{IllegalIngredients ? newItem:
    ->illegal_item(newItem)->->
}

~ temp anySane = true
~ temp offender = ()
~ anySane = anySane and check_against_sandwich(newItem, PeanutButterAndJam, offender)
~ anySane = anySane and check_against_sandwich(newItem, MeatSandwhich, offender)

+ (comply) {anySane} ->
    ++ {offenses >= 3} ->
        {~He can barely speak through the tears.|"Yeah fine."|"Whatever."}
    ++ {offenses > 0} ->
        {~"Okay."|"Fine."|"Sure."}
    ++ ->
        {~"Sure thing."|"Okay sure."|"Whatever you want."|He nods.}
    -- ->add_ingredient(newItem)->
+ ->
    ->increduluous(newItem, offender, ->comply)->
- 
->->

= add_ingredient(item)
~ temp name = print_ingredient(item)
~ temp other = LIST_RANDOM(Ingredients)
{
    - item ^ (PeanutButter, Jam, Nutella, Mayo):
        He {~spreads|slathers} the {name} over the {other:{print_ingredient(other)}|bread}.
        {It's wet and sloppy.|It's nice and runny.|}
    - item ^ (OrangeJuice, Milk):
        {In horror|With great reservation|Shaking}, he pours the {name} all over your sandwich. 
        {other:
            <> It splashes off the {print_ingredient(other)}.
        }
    - else:
        {&
            - He adds the {name}
            - He places the {name} on your sandwich
        }
        {other: 
            {~
                - <>, right atop the {print_ingredient(other)}
                - <>, right above the {print_ingredient(other)}
                - <>, careful to fit it with the {print_ingredient(other)}
            }
        }
        <>.
            
}
~ Ingredients += item
->->

= illegal_item(item)
{|->second|->third}
His gaze rises to meet yours.

"Uh. What?"

* "I must have it."
* "There can be no delay."
* "What's wrong?"

-

~ temp name = print_ingredient(item)

"S--sir... you can't put {name} on a sandwich."

-(opts)
* "Do you not sell {name}?"[] you ask.
    "Well, we do but..."
    ->opts
* "I am the master here."
    And you see it. He begins to understand.
    "O--okay."
    ~ offenses++
    ->add_ingredient(item)->
* "Fine, fine, something else then."

- ->->

- (second)

"You, you can't be serious."

* "I'm afraid I am."
    He sees now who he's dealing with.
    ~ offenses++
    ->add_ingredient(item)->
* "Do not question me."
    That gets him.
    ~ offenses++
    ->add_ingredient(item)->
* "I'm not. It's a joke. Don't be silly."
    "Oh--okay..."
- ->->

- (third)

{No talk back from him now. <>|}

~ offenses++
->add_ingredient(item)->->

= choose_ingredient_threads
~ temp unusedIngredients = LIST_INVERT(Ingredients)
{assemble < 3:
    ~ unusedIngredients -= IllegalIngredients
}
<-random_ingredient_choices(unusedIngredients)
->DONE

= random_ingredient_choices(unused)
{CHOICE_COUNT() >= 3 or not unused: ->DONE}
~ temp item = pop_random(unused)
<-ingredient_choice(item)
<-random_ingredient_choices(unused)

= ingredient_choice(item)
~ temp request = "{~I want|Give me|This is gonna need}"
+ "{request} {print_ingredient(item)}"
    <> you explain.
    ->process_choice(item)->assemble
->DONE


= process_choice(item)
->check_sandwhich_sanity(item)->
->->

= increduluous(newItem, offender, ->comply)
VAR lastOffenderPair = ()
VAR complainedAbout = ()
{complainedAbout ? offender: 
    ->->comply
}
~ complainedAbout += offender

// Record last pair of offensive items
~ lastOffenderPair = ()
~ lastOffenderPair += newItem
~ lastOffenderPair += offender

{stopping:
    - "Uh. Wait. You want {print_ingredient(newItem)} with your {print_ingredient(offender)}?"
    - "Sir, {print_ingredient(newItem)} does not go with {print_ingredient(offender)}."
    - "Please. Sir. You can't make me. {print_ingredient(newItem)} and {print_ingredient(offender)}." He begins to cry. "I can't do it."
    - -> try_complete.no_serve
}

-(opts)
* "Is this a problem?"
    "Well, I mean." He scratches his head. "It's... It's simply not done."
    <-more
    <-opts
    ->DONE
    -- (more)
    ** "It is now."
        Another stroke of genius.
* "I won't say it again."
* {CHOICE_COUNT() < 2} "The customer is always right[."]," you inform him.
* {CHOICE_COUNT() < 2} "I won't be questioned."
+ {CHOICE_COUNT() < 2} "Do it now."
+ "Really? What goes with {print_ingredient(offender)}?"[] you ask{once:, almost offended by his insinuation that he is the wiser being}.
    ~ temp suggestion = generate_suggestion(offender)
    ++ {suggestion} ->
        {"Uh, {print_ingredient(suggestion)}?"|"{print_ingredient(suggestion)}!"}
        ---(suggestion_given)
        *** "Are you sure?"[] you ask. That doesn't sound right at all.
            He stares back blankly. "What are you even saying?"
            You could ask him the same thing, frankly.
            ->suggestion_given
        +++ "Okay, let's try {print_ingredient(suggestion)} then."
            ~ newItem = suggestion
        +++ "No, I don't think so. {print_ingredient(newItem)}."
            Surely you've said it enough times already.
    ++ ->
        He clutches his head. 
        "You've already asked for everything that goes with {print_ingredient(offender)}. There's nothing else to put on!"
        What... what could he be saying. That your sandwich is complete?
        +++ He's right.[] You straighten your spine and declare.
            "This sandwich is complete!"
            ->->try_complete
        +++ He couldn't be more wrong.
            This day is far from over, for the both of you.
            ->->

- 
~ offenses++
->add_ingredient(newItem)->->

= try_complete

+ {not Ingredients} ->

    {stopping:
        - "Uh."
        
        He looks down at the glorious, vast expanse of exposed bread beneath him then back to you.
        - He blinks.
        - ->finish_and_cut
    }
    
    -- (confused_empty)
    ** "Yes?"
        "This... sandwich." He holds up the two empty flaps of bread. "It's empty."
        What is he saying?
        <-what_is_he_saying
        <-confused_empty
        ->DONE
        --- (what_is_he_saying)
        *** "Are you saying, I am nothing?"
            "No, no, no." He begins to sweat. "It's just that--"
        ---
        <-im_everything
        <-confused_empty
        ->DONE
        --- (im_everything)
        *** "I am everything!"
            ->attack
    ** (slice_it)"Slice it in quarters, please."
        "But--"
        ->confused_empty
    ** {slice_it} "Slice it. Now."
    ** Sweat.
        There's something off-putting about the way this appendage is looking at you. What has happened?
        ->confused_empty
    ++ "Actually, there's more! Much more!"
        He bites his lip. Nervously? No. In anticipation. Anticipation for... ->assemble.go
    
    -- (finish_and_cut) "Oh--okay, sir." Gingerly, he lifts one delicate, dry slice and places it upon the other. 
    ->opts_sane_end
    
* {Ingredients ^ IllegalIngredients or offenses > 1} ->

    -- (no_serve) He shakes his head. 
    
    What is this? What is happening? This motion, all this drooping. This is... this is entirely wrong.
    
    "Sir, I... I can't.  I simply can not serve you this sandwich."
    -- (illegal_finish)
    ** "But why!"
        +++ {Ingredients ^ IllegalIngredients} ->
            "It has {print_ingredient(LIST_RANDOM(Ingredients ^ IllegalIngredients))}!"
        +++ {lastOffenderPair} ->
            ~ temp a = pop_random(lastOffenderPair)
            ~ temp b = pop_random(lastOffenderPair)
            "It has {print_ingredient(a)} AND {print_ingredient(b)}!"
        +++ ->
            // This should never happen but just in case.
            "I just... I can't!"
        --- <> he screams. 
        ->illegal_finish
    ** "We've been over this!"
    ** "I am in charge. I have the power."
    -- 
    He slams his fist on the counter. 
    "I won't do it!"
    That's it.
    ** Storm out.
        ->leave
    ** "You'll rue this day."
        ->attack
    
* ->

    He nods{offenses > 0:, though he seems a little nervous about it. Probably just jitters, he is face to face with excellence after all}. "Sure, man."
    
    Man. Sure <i>man</i>. He sees you as one of them.
    
    -- (opts_sane_end)
    ** "This wasn't my first[."]," you explain, pressing your advantage.
        "Uh. Okay."
        ->opts_sane_end
    ** "This won't be the last."
        "Oh..."
        ->opts_sane_end
    ** "You may go now."
        "I, uh. Don't get off till 3."
        ->opts_sane_end
    ** {CHOICE_COUNT() < 3} "Fare Well."
        You want to wish him the best. Soon his entire planet will be re-tooled for inter-galactic sandwich manufacture. He has proved himself worthy of seeing that future.
        For now.
        
    -- You stroll out, sandwhich in hand and pride in your heart. You have made first contact with this species and even ingratiated yourself to their servile classes.
    
    You admire it, your beautiful creation. ->describe_sandwich->
    
    Only one task left.
    
    ** [Eat.]
        You peel open the sandwhich and slam it against your face, the mandibles on either of your cheeks opening to make short work of it. 
        
        Another job well done.
        
- ->end

= attack

You transmit immediately and within minutes armed personnel carriers lying in wait in hyperspace jump into orbit and spill their soldiers over this impudent world. Fields burn, cities crumble, and orphans of the invasion scattered to the wind as families are torn to shreds in combat.

And this man, this proprietor, this mere appendage of an absent, feeble master, him you will save for last. 

<i>World</i> famous? <b>World!?!</b> Now it is your world. And they will answer for their crimes.

->end

= leave

You storm out, incensed. Is this how these beings treat their own kind, like deviants! Like scum! 

You ordered a great sandwhich; this no one can deny. No one would dare! And yet.

You return to your ship and leave this world. You didn't want it in your empire anyway.

->end

= describe_sandwich
{
    - Ingredients == (PeanutButter, Jam):
        A peanut butter and jam sandwich, complete with two slices of soggy bread, a staple of every human child. You wonder if they will taste the same?
    - Ingredients == (Nutella):
        Nothing but a slab of thick chocolate spread soaking two soggy slices of bread. You've witnessed many a human child threaten to kill for this; a useful factoid to keep handy for their eventual recruitment to subjugate their parents.
    - Ingredients ^ (PeanutButter, Jam) and LIST_COUNT(Ingredients) == 3:
        A peanut butter and jam sandwich, complete with its star-crossed lover: {Ingredients - (PeanutButter, Jam)}. Nothing could be more harmonious.
    - Ingredients == (Bacon, Lettuce, Tomato):
        A classic Bee El Tee, which you understand to be an equisite French dish. Or was it Mexican? Doesn't matter.
    - Ingredients ? Eggs:
        A sandwich with fresh ovum. Perhaps one day you'll have sufficiently gained their trust to secure a sandwich with one of their own species ovums, but the unfertilized egg of their domestic foul is just as well for now. {LIST_COUNT(Ingredients) > 1: It goes swell with {LIST_RANDOM(Ingredients - Eggs)}.} 
}
->->

= end

<b>THE END</b>
->END

=== function check_against_sandwich(newItem, sandwich, ref offender)
// Don't bother if we're not even trying to build this sandwich
{not (Ingredients ^ sandwich):
    ~ return true
}
{
    - sandwich has newItem: 
        ~ return true
    - else:
        ~ temp shared = Ingredients ^ sandwich
        ~ offender = pop_random(shared)
        ~ return false
}

=== function now_has(set, newItem, ref badItem)
~ temp withoutNew = set - newItem
~ badItem = pop_random(withoutNew)
~ return (Ingredients + newItem) ? set and set ? newItem

=== function pop_random(ref _list) 
    ~ temp el = LIST_RANDOM(_list) 
    ~ _list -= el
    ~ return el 

=== function print_ingredient(item)
{item:
    - PeanutButter:
        ~ return "Peanut Butter"
    - OrangeJuice:
        ~ return "Orange Juice"
}
~ return item

=== function generate_suggestion(item)
~ temp suggestion = ()
~ suggestion = find_suggestion_in(item, MeatSandwhich)
{suggestion:
    ~ return suggestion
}
~ return find_suggestion_in(item, PeanutButterAndJam)

=== function find_suggestion_in(item, sandwich)
{
    - sandwich ? item:
        ~ return LIST_RANDOM(sandwich ^ LIST_INVERT(Ingredients))
    - else:
        ~ return ()
}

=== function is_browser()
~ return false