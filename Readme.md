# Ports.jl

Makes it easy to manage a stream of asynchronously generated values.

## Comparison to `Channel`

Channels block the producing process when the consuming process can't keep up. Ports don't and in fact provide no way for the producer to know if the consumer is keeping up or not.

With channels a consumer can never be sure they are seeing all values placed on the channel since there may be other consumers which are competing with it. With Ports all consumers will see all values. Though unlike Channels, Ports don't buffer values by default so consumers will only ever see values that show up after they subscribe. Buffering Ports are an option though
