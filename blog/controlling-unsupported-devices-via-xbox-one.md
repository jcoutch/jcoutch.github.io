# Controlling unsupported devices via XBox One

**Author:** Joe
<br/>**Date:** 03/06/2016 10:06:00

<p>The XBox One has a very useful feature that will turn on all your devices when it's starting up. &nbsp;Unfortunately, Microsoft has been SLOOOOOW on adding new devices. &nbsp;Imagine my surprise when I tried configuring my Pyle projector, and none of the remote codes worked. &nbsp;Well, here's a nerdy way to get around it!</p>
<p>Pick yourself up an&nbsp;<a href="http://www.amazon.com/Arduino-Board-Module-ATmega328P-Blue/dp/B008GRTSV6/">Arduino Uno</a>,&nbsp;<a href="http://www.amazon.com/gp/product/B0181R16V0">LinkSprite IR shield</a>, the <a href="https://github.com/z3t0/Arduino-IRremote/releases">Arudino-IRremote</a>&nbsp;library (drop the IRremote folder in "Documents\Arduino\Libraries") and upload&nbsp;the code below:</p>
<pre class="brush:cpp;auto-links:false;toolbar:false" contenteditable="false">#include &lt;IRremote.h&gt;

int RECV_PIN = 11;
IRrecv irrecv(RECV_PIN);

// Depending on the board you use, send pin could be
// different.  For example, the Mega uses digital Pin 9.
IRsend irsend;
decode_results results;

void setup() {
  irrecv.enableIRIn(); // Start the receiver
}

void loop() {
  if (irrecv.decode(&amp;results)) {
    translate();
    irrecv.resume(); // Receive the next value
  }
  delay(100);
}

// Useful for some projectors
void sendTwiceNEC(unsigned long code, int bits) {
  // Delay before sending
  delay(1000);

  irsend.sendNEC(code, bits);
  delay(500);
  irsend.sendNEC(code, bits);
  delay(500);
}

void translate() {
  switch(results.value) {

    case 0x20DF10EF: // LG 47" TV - Power Button
      // Pyle Home PRJLE82H Projector - Power Button
      sendTwiceNEC(0x61D650AF, 32);
      break;
  }

  irrecv.enableIRIn();
  return;
}
</pre>
<p>What this does, is waits for the power signal from an LG remote, and once it's received, sends two pulses of the Pyle projector's power button (since that's what's required for the shutdown signal on my projector.)</p>
<p><img src="/image.axd?picture=/ir-transceiver/ir_translator.jpg" alt="" /></p>
<p>To adapt it to your device, I recommend loading the&nbsp;IRrecvDumpV2 sketch onto your Arduino to get the hex codes you'll need, and plug them into the switch block above. &nbsp;Or, you can try to extrapolate the information from the <a href="http://lirc.sourceforge.net/remotes/">LIRC Remote Database</a>. &nbsp;Also, I'd remove one of the send/delay combinations in sendTwiceNEC if you're controlling a TV/other device. &nbsp;And if your device doesn't use NEC codes, check out some of the example sketches or IRremote documentation&nbsp;for other manufacturers (like Sony.)</p>
<p><strong>Note</strong> - If you find the transmitter isn't working, and you chose a board other than the Uno, check out "IRRemoteInt.h" in the IRremote library for "TIMER_PWM_PIN". &nbsp;This defaults to digital IO pin 3 for the Uno, but varies for different boards. &nbsp;Since I used an Arduino Mega 2560, I had to add a jumper on my Linksprite shield from pin 3 to pin 9.</p>
