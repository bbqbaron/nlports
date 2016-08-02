const nlp = require('nlp_compromise'),
      r = require('ramda');

const app = Elm.Main.fullscreen();

const callAll = ({commands: [first, ...rest], text}) =>
    r.reduce(
        (acc, token) =>
            r.type(acc[token]) === "Function" ?
            acc[token]() :
            acc[token],
        nlp[first](text),
        rest
    );

const log = r.tap(x => {console.log(x);});

app.ports.nlpCmd.subscribe(
    r.pipe(
        log,
        callAll,
        log,
        app.ports.nlpResp.send
    )
);
