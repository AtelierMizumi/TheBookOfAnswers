import json
import random
import os

# Base real historical quotes for each tome
base_quotes = {
    "universal": [
        {"text": "The impediment to action advances action. What stands in the way becomes the way.", "attribution": "Marcus Aurelius"},
        {"text": "We suffer more often in imagination than in reality.", "attribution": "Seneca"},
        {"text": "Nature does not hurry, yet everything is accomplished.", "attribution": "Lao Tzu"},
        {"text": "To know what you know and what you do not know, that is true knowledge.", "attribution": "Confucius"},
        {"text": "The only true wisdom is in knowing you know nothing.", "attribution": "Socrates"},
        {"text": "Happiness depends upon ourselves.", "attribution": "Aristotle"},
        {"text": "Do not spoil what you have by desiring what you have not.", "attribution": "Epicurus"},
        {"text": "He who has a why to live for can bear almost any how.", "attribution": "Friedrich Nietzsche"},
        {"text": "In the midst of chaos, there is also opportunity.", "attribution": "Sun Tzu"},
        {"text": "The journey of a thousand miles begins with one step.", "attribution": "Lao Tzu"},
    ],
    "love": [
        {"text": "The minute I heard my first love story, I started looking for you.", "attribution": "Rumi"},
        {"text": "Whatever our souls are made of, his and mine are the same.", "attribution": "Emily Brontë"},
        {"text": "Doubt thou the stars are fire; Doubt that the sun doth move; Doubt truth to be a liar; But never doubt I love.", "attribution": "William Shakespeare"},
        {"text": "If I know what love is, it is because of you.", "attribution": "Hermann Hesse"},
        {"text": "Love is composed of a single soul inhabiting two bodies.", "attribution": "Aristotle"},
        {"text": "Where there is love there is life.", "attribution": "Mahatma Gandhi"},
        {"text": "We loved with a love that was more than love.", "attribution": "Edgar Allan Poe"},
        {"text": "There is no remedy for love but to love more.", "attribution": "Henry David Thoreau"},
        {"text": "Love is a friendship set to music.", "attribution": "Joseph Campbell"},
        {"text": "You don't love someone for their looks, or their clothes, or for their fancy car, but because they sing a song only you can hear.", "attribution": "Oscar Wilde"},
    ],
    "fire": [
        {"text": "Let your plans be dark and impenetrable as night, and when you move, fall like a thunderbolt.", "attribution": "Sun Tzu"},
        {"text": "Veni, vidi, vici. (I came, I saw, I conquered.)", "attribution": "Julius Caesar"},
        {"text": "If you are going through hell, keep going.", "attribution": "Winston Churchill"},
        {"text": "Courage is not having the strength to go on; it is going on when you don't have the strength.", "attribution": "Theodore Roosevelt"},
        {"text": "I came, I saw, I conquered.", "attribution": "Julius Caesar"},
        {"text": "Victory belongs to the most persevering.", "attribution": "Napoleon Bonaparte"},
        {"text": "Never interrupt your enemy when he is making a mistake.", "attribution": "Napoleon Bonaparte"},
        {"text": "The bold are helpless without cleverness.", "attribution": "Euripides"},
        {"text": "Fortune favors the bold.", "attribution": "Virgil"},
        {"text": "Do not pray for an easy life, pray for the strength to endure a difficult one.", "attribution": "Bruce Lee"},
    ],
    "brutal": [
        {"text": "Man is condemned to be free.", "attribution": "Jean-Paul Sartre"},
        {"text": "Hell is other people.", "attribution": "Jean-Paul Sartre"},
        {"text": "I am looking for a human.", "attribution": "Diogenes"},
        {"text": "To live is to suffer, to survive is to find some meaning in the suffering.", "attribution": "Friedrich Nietzsche"},
        {"text": "The world breaks everyone and afterward many are strong at the broken places.", "attribution": "Ernest Hemingway"},
        {"text": "We are all in the gutter, but some of us are looking at the stars.", "attribution": "Oscar Wilde"},
        {"text": "People do not wish to appear foolish; to avoid the appearance of foolishness, they are willing to remain actually fools.", "attribution": "Alice Walker"},
        {"text": "Most people are other people. Their thoughts are someone else's opinions, their lives a mimicry, their passions a quotation.", "attribution": "Oscar Wilde"},
        {"text": "You will never do anything in this world without courage. It is the greatest quality of the mind next to honor.", "attribution": "Aristotle"},
        {"text": "The truth will set you free, but first it will piss you off.", "attribution": "Gloria Steinem"},
    ],
    "midnight": [
        {"text": "I became insane, with long intervals of horrible sanity.", "attribution": "Edgar Allan Poe"},
        {"text": "The oldest and strongest emotion of mankind is fear, and the oldest and strongest kind of fear is fear of the unknown.", "attribution": "H.P. Lovecraft"},
        {"text": "All that we see or seem is but a dream within a dream.", "attribution": "Edgar Allan Poe"},
        {"text": "Deep into that darkness peering, long I stood there wondering, fearing, doubting, dreaming dreams no mortal ever dared to dream before.", "attribution": "Edgar Allan Poe"},
        {"text": "I love the dark hours of my being.", "attribution": "Rilke"},
        {"text": "There are nights when the wolves are silent and only the moon howls.", "attribution": "George Carlin"},
        {"text": "I often think that the night is more alive and more richly colored than the day.", "attribution": "Vincent Van Gogh"},
        {"text": "Night is a time of rigor, but also of mercy.", "attribution": "Isaac Bashevis Singer"},
        {"text": "To the mind that is still, the whole universe surrenders.", "attribution": "Lao Tzu"},
        {"text": "Do not go gentle into that good night.", "attribution": "Dylan Thomas"},
    ],
    "chaos": [
        {"text": "I am entirely made of flaws, stitched together with good intentions.", "attribution": "Augusten Burroughs"},
        {"text": "I embrace the chaos. It is the only thing that makes sense.", "attribution": "Anonymous"},
        {"text": "You must have chaos within you to give birth to a dancing star.", "attribution": "Friedrich Nietzsche"},
        {"text": "Only those who will risk going too far can possibly find out how far one can go.", "attribution": "T.S. Eliot"},
        {"text": "Normal is an illusion. What is normal for the spider is chaos for the fly.", "attribution": "Charles Addams"},
        {"text": "The world is a tragedy to those who feel, but a comedy to those who think.", "attribution": "Horace Walpole"},
        {"text": "Art is nothing but a localized, physical expression of a cosmic, spiritual chaos.", "attribution": "Carl Jung"},
        {"text": "I can resist everything except temptation.", "attribution": "Oscar Wilde"},
        {"text": "Not all those who wander are lost.", "attribution": "J.R.R. Tolkien"},
        {"text": "We are all mad here.", "attribution": "Lewis Carroll"},
    ]
}

# Procedural generation templates
# Universal
u_verbs = ["Trust in", "Observe", "Wait for", "Listen to", "Release", "Embrace", "Seek", "Question", "Reflect upon", "Accept", "Surrender to", "Understand", "Navigate", "Witness", "Acknowledge", "Follow"]
u_nouns = ["the silence", "the unseen path", "the turning tide", "the inevitable", "the unknown", "the shifting winds", "the current", "the natural order", "the space between", "the inner voice", "the unfolding moment", "the quiet truth"]
u_conds = ["before acting.", "when in doubt.", "and the way will open.", "despite the fear.", "to find clarity.", "without hesitation.", "and let it go.", "with an open heart.", "for it holds the answer."]

# Love
l_starts = ["The heart requires", "A true bond needs", "Love blossoms in", "Connection is found through", "To love deeply is to", "Passion thrives on", "The soul yearns for", "True intimacy begins with", "Romance awakens", "Devotion requires", "A lasting spark depends on", "Vulnerability is the key to"]
l_mids = ["a quiet moment of", "the sudden spark of", "an unexpected display of", "the subtle art of", "a deep well of", "the courage to show", "the simple act of", "a shared understanding of"]
l_ends = ["vulnerability.", "patience.", "shared silence.", "unspoken understanding.", "mutual respect.", "forgiveness.", "giving without expectation.", "listening closely.", "gentle persistence.", "honest reflection.", "unconditional support.", "passionate truth."]

# Fire
f_actions = ["Strike", "Advance", "Conquer", "Burn", "Ignite", "Destroy", "Push forward", "Seize", "Command", "Defy", "Overcome", "Dominate", "Rally", "Unleash"]
f_targets = ["the obstacle", "the hesitation", "the fear", "the enemy within", "the boundaries", "the limitations", "the impossible", "the past", "the doubt", "the weakness"]
f_reasons = ["with absolute fury.", "without looking back.", "and claim your victory.", "until nothing remains.", "for fortune favors the bold.", "and leave no regrets.", "with unwavering resolve.", "to forge a new path.", "before they strike first.", "and become the flame."]

# Brutal
b_starts = ["You already know", "Stop pretending", "Your ego is hiding", "The harsh truth is", "Face the fact that", "No one cares about", "You are wasting time on", "It is foolish to expect", "Accept that", "Stop avoiding"]
b_mids = ["the obvious reality of", "the painful truth behind", "the meaningless nature of", "the absolute certainty of", "the brutal consequence of"]
b_ends = ["the inevitable.", "your own flaws.", "that you are wrong.", "the answer you avoid.", "an impossible outcome.", "what you cannot control.", "someone else's opinion.", "your own excuses.", "meaningless distractions.", "your own failure."]

# Midnight
m_starts = ["In the deep shadows,", "When the moon rises,", "The darkness reveals", "Listen to the night,", "Dreams whisper of", "The void speaks of", "At the witching hour,", "In the stillness,", "When the light fades,"]
m_mids = ["you will discover", "the soul confronts", "the mind uncovers", "the silence answers with", "the stars illuminate"]
m_ends = ["what the sun hides.", "forgotten truths.", "the face of fear.", "secrets of the soul.", "the end of things.", "silent warnings.", "echoes of the past.", "the infinite abyss.", "a haunting reality."]

# Chaos
c_starts = ["Roll the dice and", "Flip a coin, then", "Expect the opposite of", "Embrace the absurdity of", "Throw away the plan for", "Dance with the madness of", "The only certainty is", "Rejoice in", "Surrender to"]
c_mids = ["the beautiful paradox of", "the sudden arrival of", "the strange twist of", "the unpredictable nature of", "the bizarre reality of"]
c_ends = ["the impending disaster.", "what you desire.", "absolute nonsense.", "the unpredictable outcome.", "the beautiful mess.", "a complete paradox.", "the cosmic joke.", "the whirlwind of chance.", "the absolute unknown."]

def generate_procedural_quote(tome_id):
    if tome_id == "universal":
        return f"{random.choice(u_verbs)} {random.choice(u_nouns)} {random.choice(u_conds)}"
    elif tome_id == "love":
        return f"{random.choice(l_starts)} {random.choice(l_mids)} {random.choice(l_ends)}"
    elif tome_id == "fire":
        return f"{random.choice(f_actions)} {random.choice(f_targets)} {random.choice(f_reasons)}"
    elif tome_id == "brutal":
        return f"{random.choice(b_starts)} {random.choice(b_mids)} {random.choice(b_ends)}"
    elif tome_id == "midnight":
        return f"{random.choice(m_starts)} {random.choice(m_mids)} {random.choice(m_ends)}"
    elif tome_id == "chaos":
        return f"{random.choice(c_starts)} {random.choice(c_mids)} {random.choice(c_ends)}"
    return "The answer is clouded."

# Generate 150 quotes per tome
final_database = {}

for tome, quotes in base_quotes.items():
    tome_quotes = []
    # Add the base historical quotes
    for q in quotes:
        tome_quotes.append({"text": q["text"], "attribution": q["attribution"], "weight": 8})
    
    # Generate the rest up to 150
    generated_set = set()
    attempts = 0
    while len(tome_quotes) < 150 and attempts < 1000:
        attempts += 1
        new_quote = generate_procedural_quote(tome)
        if new_quote not in generated_set:
            generated_set.add(new_quote)
            # Give procedural quotes an attribution of 'The Oracle' or None
            attribution = random.choice([None, None, "The Oracle", "Ancient Scribe"])
            weight = random.randint(3, 7)
            tome_quotes.append({"text": new_quote, "attribution": attribution, "weight": weight})
    
    random.shuffle(tome_quotes)
    final_database[tome] = tome_quotes

# Ensure the assets/data directory exists
os.makedirs('assets/data', exist_ok=True)

# Write to JSON
with open('assets/data/tomes.json', 'w') as f:
    json.dump(final_database, f, indent=2)

print("Generated assets/data/tomes.json with 900+ quotes successfully!")
