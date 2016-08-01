module NLP.Command exposing (commands, NlpCmd)

type Genus =
    Text | Sentence | Term | Verb | Adjective | Adverb | Noun | Value | Person | Date | Place | Organization

type NlpCmd =
    Past
    | Plural
    | Conjugate

past = Past
plural = Plural
conjugate = Conjugate

commands = [past, plural, conjugate]
