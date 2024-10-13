import board
import busio
import adafruit_mpr121
import usb_midi
import adafruit_midi
# from adafruit_midi.control_change import ControlChange
from adafruit_midi.note_off import NoteOff
from adafruit_midi.note_on import NoteOn

i2c = busio.I2C(board.GP1, board.GP0)
mpr121 = adafruit_mpr121.MPR121(i2c)
midi = adafruit_midi.MIDI(
    midi_out=usb_midi.ports[1],
    out_channel=0,
)

# Finger to Hole Number
# Left  = Thumb: 0, Index: 1, Middle: 2, Ring: 3
# Right = Thumb: X, Index: 4, Middle: 5: Ring: 6, Pinky: 7

# Hole number to Pin
# Pin:  0, 1, 2, 3, 4, 5, 6, 7,  8,  9,  A,  B
# Hole: -, X, 0, 1, 2, 3, 4, 5, 6a, 6b, 7a, 7b

fingering = {
    # 7766543210X- 
    0b000000010110: 'C7',
    0b000000001110: 'B6',
    0b000000011110: 'A6',
    0b000000111110: 'G6',
    0b001110111110: 'F#6',
    0b111101111110: 'F6',
    0b000011111110: 'E6',
    0b000111111110: 'D#6',
    0b001111111110: 'D6',
    0b011111111110: 'C#6',
    0b111111111110: 'C6',
}

def compute_note():
    holes = 0
    for i in range(12):
        if mpr121[i].value:
            # print(f'Pin {i}, bits: {(1 << i)}, holes: {holes}')
            holes |= 1 << i

    # if holes > 0:
    #     print(f'Holes {holes}')
        
    return fingering[holes] if holes in fingering else None

print('Lets play!')
current_note = None
while True:
    next_note = compute_note()
    if next_note == current_note:
        continue
        
    if current_note is not None:
        midi.send(NoteOff(current_note))
        
    if next_note is not None:
        print(next_note)
        midi.send(NoteOn(next_note))
    
    current_note = next_note
