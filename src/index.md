---
layout: page
---

<link rel="stylesheet" href="{{'/assets/theming/theme.css' | url }}" />

# Small-E Demo page

## Abstract:
Recent advancements in text-to-speech (TTS) powered by
language models have showcased remarkable capabilities in
achieving naturalness and zero-shot voice cloning. Notably,
the decoder-only transformer is the prominent architecture in
this domain. However, transformers face challenges stemming
from their quadratic complexity in sequence length, imped-
ing training on lengthy sequences and resource-constrained
hardware. Moreover they lack specific inductive bias with
regards to the monotonic nature of TTS alignments. In
response, we propose to replace transformers with emerging
recurrent architectures and introduce specialized cross-attention
mechanisms for reducing repeating and skipping issues.
Consequently our architecture can be efficiently trained on long
samples and achieve state-of-the-art zero-shot voice cloning
against baselines of comparable size




<table >
    <tr >
    <th> Model </th>
    <th> Params. </th>
    <th> Rel. size</th>
    <th> Vocoder </th>
    </tr>
    <tr>
    <td> Small-E (ours) </td>
    <td> 64M </td>
    <td> 1x </td>
    <td> Vocos 3kbps </td>
    </tr>
    <tr>
    <td> YourTTS </td>
    <td> 86M </td>
    <td> 1.3x </td>
    <td> End-to-End</td>
    </tr>
    <tr>
    <td> Metavoice</td>
    <td> 1.2B </td>
    <td> 18.75x </td>
    <td> Multiband Diffusion + Postnet</td>
    </tr>

    <tr>
    <td> VALL-E</td>
    <td> 2x150M </td>
    <td> 4.6x </td>
    <td> EnCodec 6kbps</td>
    </tr>

</table>

<br>
<br>

### Comparison with baselines

Prompt is the speaker reference given to each model.

<table>
    <tr>
    <th>Text</th>
    <th>Prompt</th>
    <th>Small-E (ours)</th>
    <th>YourTTS</th>
    <th>Metavoice</th>
    <th>Ground Truth</th>
    </tr>
{% for row in data %}
    <tr style="border-bottom: 1px solid #000;">
        <td>  {{ row.text }}</td>
        <td><audio controls=""><source src="/assets/samples/selected_pair/prompt/{{ row.id}}_prompt.wav" type="audio/x-wav"></audio></td>
        <td><audio controls=""><source src="/assets/samples/selected_pair/smalle/{{ row.id }}_synth.wav" type="audio/x-wav"></audio></td>
        <td><audio controls><source src="/assets/samples/selected_pair/yourtts/{{ row.id }}_synth.wav" type="audio/x-wav"></audio></td>
        <td><audio controls><source src="/assets/samples/selected_pair/metavoice/{{ row.id }}_synth.wav" type="audio/x-wav"></audio></td>
        <td><audio controls><source src="/assets/samples/selected_pair/target/{{ row.id }}_target.wav" type="audio/x-wav"></audio></td>
    </tr>
{% endfor %}
</table>
</tr>
<table>
    <tr>
    <th>Text</th>
    <th>Prompt</th>
    <th>Small-E (ours)</th>
    <th>VALL-E</th>
    <th>Ground Truth</th>
    </tr>

<br>
<br>
<br>

### Comparison with VALL-E

We add samples from the demo page of VALL-E since there is no official implementation.

{% for row in valle %}
    <tr style="border-bottom: 1px solid #000;">
        <td>  {{ row.text }}</td>
        <td><audio controls=""><source src="/assets/samples/valle/{{ row.prompt }}" type="audio/x-wav"></audio></td>
        <td><audio controls=""><source src="/assets/samples/valle/{{ row.smalle}}" type="audio/x-wav"></audio></td>
        <td><audio controls><source src="/assets/samples/valle/{{ row.valle }}" type="audio/x-wav"></audio></td>
        <td><audio controls><source src="/assets/samples/valle/{{ row.gt }}" type="audio/x-wav"></audio></td>
    </tr>
{% endfor %}
</table>
</tr>
