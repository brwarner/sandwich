#title:Sandwich
#subtitle:by Brook Warner Jensen

~ SEED_RANDOM(255)

At long last, you've arrived. 

* Earl's World Famous Deli
-

World famous. <i>World</i>. Famous. Deli. 

You have spent the last sixteen of this world's months observing them from your covert reconnisance craft in orbit. Studying their language, culture, security, and now, outfitted with incredible knowledge about their ways you have graduated to the next phase: integrating into their population. Participating in their rituals. And here, now, on a street so critical to their identity they simply call it "Main Street" you are ready to order a sandwich.

You have witnessed dozens--no, hundreds of sandwich orders thus far, and it is your belief that what you order will put every one of them to shame.

The line peels off, one human at a time, until finally it is you, standing face to face with the proprietor.

His nametag reads: Fred, but you understand that by custom you should see him as a mere appendage of his master. Earl.

He looks up from the counter. Nods.

-(intro)
* (nod_1) [Nod back.]You nod.
    He nods back.
    ->intro
* (nod_2) {nod_1} [Nod again.] You give him another nod.
    He looks around, clears his throat, and nods back. You can see it in his eyes, he knows now he is dealing with a champion of commerce.
    ->intro
* {nod_2} [Nod once more.] You nod once more, and it's as clean and practised as every nod you've given before.
    "Uh," he says, scratching his cheek. "Can I get you something, sir?"
    ->intro
* (vend) {not nod_2} "Vend me[."]," you bark.
    "Uh." He clears his head. "What?"
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

He extracts from the warmer two slices of bread.

This is it.

->assemble

= assemble

LIST Ingredients = Bacon, Lettuce, Tomato, PeanutButter, Cheese, Eggs, Milk, Jam, Salami, Mayo, OrangeJuice, Nutella

VAR PeanutButterAndJam = (PeanutButter, Jam, Nutella)
VAR MeatSandwhich = (Eggs, Bacon, Salami, Lettuce, Tomato, Cheese, Mayo)
VAR IllegalIngredients = (Milk, OrangeJuice)

{&You want...|Next is...|Without a doubt, you need...}

- (go)

<-choose_ingredient_threads
+ "This sandwhich is complete!"
    ->try_complete

= check_sandwhich_sanity(newItem)
{IllegalIngredients ? newItem:
    ->illegal_item(newItem)->->
}

~ temp anySane = true
~ temp offender = ()
~ anySane = anySane and check_against_sandwich(newItem, PeanutButterAndJam, offender)
~ anySane = anySane and check_against_sandwich(newItem, MeatSandwhich, offender)

TODO Vary these lines if you've made offensive choices already.
{anySane: 
    {~"Sure thing."|"Okay sure."|"Whatever you'd want."|He nods.}
    ->add_ingredient(newItem)->
    ->->
}

->increduluous(newItem, offender)->
- ->->

= add_ingredient(item)
~ temp name = print_ingredient(item)
~ temp other = LIST_RANDOM(Ingredients)
{
    - item ^ (OrangeJuice, Milk):
        {In horror|With great reservation|Shaking}, he pours the {name} all over your sandwich. 
        {other:
            <> It splashes off the {other}.
        }
    - else:
        {&
            - He adds the {name}
            - He places the {name} on your sandwich
        }
        {other: 
            {~
                - <>, right atop the {other}
                - <>, right above the {other}
                - <>, careful to fit it with the {other}
            }
        }
        <>.
            
}
~ Ingredients += item
->->

= illegal_item(item)
{|->second}
His gaze rises to meet yours.

"Uh. What?"

* "I must have it."
* "There can be no delay."
* "What's wrong?"

-

~ temp name = print_ingredient(item)

"S--sir... you can't put {name} on a sandwich."

-(opts)
* "Do you not sell {name}?"
    "Well, we do but..."
    ->opts
* "I am the master here."
    And you see it. He begins to understand.
    "O--okay."
    ->add_ingredient(item)->
* "Fine, fine, something else then."

- ->->

- (second)

"You, you can't be serious."

* "I'm afraid I am."
    He sees now who he's dealing with.
    ->add_ingredient(item)->
* "Do not question me."
    That gets him.
    ->add_ingredient(item)->
* "I'm not. It's a joke. Don't be silly."
    "Oh--okay..."
- ->->

- (third)

{No talk back from him now. <>|}

->add_ingredient(item)->->

= choose_ingredient_threads
~ temp unusedIngredients = LIST_INVERT(Ingredients)
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

= increduluous(newItem, offender)

VAR complainedAbout = ()
{complainedAbout ? offender: 
    ->add_ingredient(newItem)->->
}
~ complainedAbout += offender

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
+ "Really? What goes with {print_ingredient(offender)}?"
    TODO Item suggestion
    >> TODO Generate new item suggestion
    ->->

- ->add_ingredient(newItem)->->

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
        He bits his lip. Nervously? No. In anticipation. Anticipation for... ->assemble.go
    
    -- (finish_and_cut) "Oh--okay, sir." Carefully, he lifts one delicate, dry slice and places it gently upon the other. 
    ->opts_sane_end
    
* {Ingredients ^ IllegalIngredients} ->

    -- (no_serve) He shakes his head. 
    
    What is this? What is happening? This motion, all this drooping. This is... this is entirely wrong.
    
    "Sir, I... I can't.  I simply can not serve you this sandwhich."
    -- (illegal_finish)
    ** "But why!"
        "It has {LIST_RANDOM(Ingredients ^ IllegalIngredients)}!"
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
        
TODO Insane sandwhich ending
    
* ->

    He nods. "Sure, man."
    Sure. Sure man. Sure <i>man</i>. He sees you as one of them.
    
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
    
    Only one task left.
    
    ** [Eat.]
        You peel open the sandwhich and slam it against your face, the mandibles on either of your cheeks opening to make short work of its proteins. 
        
        Another job well done.
        
- ->END

= attack

You transmit immediately and within minutes armed personnel carriers lying in wait in hyperspace jump into orbit and spill their soldiers over the globe. Cities fall, infrastructure crumbles, and orphans of the invasion are scattered in the wind as families are torn to shreds in warfare.

And this man, this proprietor, this mere appendage of an absent, feeble master, him you save for last. 

<i>World</i> famous? <b>World!?!</b> Now it is your world. And they will answer for their crimes.

->END

= leave

You storm out, incensed. Is this how these beings treat their own kind, like deviants! Like scum! 

You ordered a great sandwhich; this no one can deny. No one would dare! And yet.

You return to your ship and leave this world. You didn't want to engulf it in your empire anyway.

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