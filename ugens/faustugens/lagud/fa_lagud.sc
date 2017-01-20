FaustFaLagud : UGen
{
  *ar { | in1, up(0.1), down(0.1) |
      ^this.multiNew('audio', in1, up, down)
  }

  *kr { | in1, up(0.1), down(0.1) |
      ^this.multiNew('control', in1, up, down)
  } 

  checkInputs {
    if (rate == 'audio', {
      1.do({|i|
        if (inputs.at(i).rate != 'audio', {
          ^(" input at index " + i + "(" + inputs.at(i) + 
            ") is not audio rate");
        });
      });
    });
    ^this.checkValidInputs
  }

  name { ^"FaustFaLagud" }
}

