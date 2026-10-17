2026-10-09 14:57
What I know so far:

~28 courses into the 286 lectures.
Material I've covered (broadstrokes):
    - Debugging:
        - the Instrumentation Trace Marcocell Unit sits on the CPU and
          communicates over Serial Wire Debugger built into the CPU. (SWD is
          ARM's answer to JTAG. It has a bidirectional wire for data, a host
          driven clock and a wire for serial wire output.) Through SWV on the
          host (CubeIDE), you can get back things that are printed to the ITM
          unit's FIFO as if they were sent to your computer's stdout.
          This requires re-implementing part of the _write() function in
          syscalls.c
          I'm sure this is a kernel level thing if I were to do it on my host
          machine. Like going directly into the printf() function's underlying
          function to write to the stdout and replacing that with writing to
          the ITM unit's FIFO.
        - There are a lot of ways to observe what is going on in your
          bitstream.
          For almost all of them, CubeIDE will let you put the device into
          debug mode (as an stm32 C/C++ application) and let you step
          into/through sections of code or stop at hardware breakpoints (which
          are these set number of register addresses that the CPU can pause
          operation at based on your hardware.) At each breakpoint, or step you
          can examine the memory address of different peripherals and things in
          your SRAM or flash. You can even write expressions to dereference
          pointers to observe what memory they have in them, add variables together, etc
          (Although I didn't exactly see how a bistream gets loaded into the
          CPU or what parts of memory that bistream automatically occupies in
          order to start running the instructions.)
        - You can also use disassembly view to see what actual instructions
          your compiler has made for the code you've written (although the
          compiler section is not covered well at all. I don't know what memory
          addresses the linker will put things in and whether those addresses
          belong to the SRAM, Flash or whatever. I don't know how the flasher
          even finds the memory address to write into and how the CPU then
          finds these instructions to run them.)
        - With another view in CubeIDE you can also get a look into all the SFR
          registers. These are the memory mapped peripherals the CPU
          communicates with over different buses (that we'll talk about later.)
          SFRs give you a view into each peripheral's status, configuration and
          allows you to change them. (I'd like to see how the addressible space
          of 2^32 addresses gets assigned different peripherals, code section,
          stack, etc). I vaguely know that different peripheral buses occupy
          different sections of memory and that this 2^32 addresses are
          actually not one contiguous section of physical memory but rather
          patched together bits of different memory on these different units.
          Eg. the SRAM might occupy from 0x0 to 0x2000_0000 and the flash might
          get the next 1 billion addresses and the AHB1 could get the next 100
          million and so on and so forth.
        - As a method of debugging, you can also observe the stack trace. This
          is a log of what methods/functions have been getting called as the
          program counter on your computer steps through the instructions.
    - Clocks
        - Most uCs ship with 3 methods to obtain their main system clock:
        HSE (High speed external) clock from a quartz crystal
        HSI (high speed internal) clock from an internal RC circuit resonator,
        or a PLL that's driven from HSE or HSI to whatever frequency it
        supports.
        - This system clock gets divided or multiplied by different AHB/APB
          prescalers as it gets routed into different sections of the
          microcontroller. The CPU might take the sys clock but some buses may
          have max limits on how fast the clock can run according to the
          peripherals that are on that bus.
        - As an energy saving measure, most peripheral clocks are disabled by
          default in the Reset & Clock Control register (RCC). The RCC register
          controls the enablement of different peripheral bus clocks.
          Before you can write any driver code to control a peripheral, you
          must first determine which AHB/APB it's connected to and enable that
          bus's clock register in the appropriate bit field.
    - Vector tables
        - A table of pointers to different sets of instructions.
        These are all pointers to exception handlers.
        Whenever an exception is raised, the Nested Vector Interrupt Controller
        is invoked and redirects CPU operation to whichever IRQ (interrupt
        request) has the highest priority.
        exceptions are either internal system exceptions (like bad
        code/errors/idk etc) or interrupts from peripherals (like a timer that
        raises an interrupt every full cycle it counts, or an ADC saying its
        conversion is done and it has a buffer of data to stream back to
        CPU/memory, etc).
        the highest priority exception is a system internal exception: the
        reset handler. It gets called when (i assume) the reset pin is held
        low/high on the microcontroller.
        There are a set bunch of IRQs on the NVIC. Most of them are weakly
        pointed at different instructions and are designed to be modified in
        the future by code that can use them. eg. have a GPIO input interrupt
        do something like blink an LED, have a timer control a GPIO, etc by
        overwriting the right interupt function. then the NVIC will point to
        the strongly defined function (yours) and handle things the way you
        wanted it to. (this may involve more layers of indirection like
        callbacks or whatever).

I'm using a much newer STM32-Nucleo-N657 board which has some security features
that the lecturer's STM32-Nucleo-F4(?) doesn't have.
Things like a secure memory section that can hold verified programs and
compiler flags that mention things like secuirity. It seems hardwired onto this
CPU to have these features. Not just software.

The project starts from absolute zero in terms of driver development. The data
sheet and associated application notes are what the lecturer uses to develop my
understanding of what is going on and how to implement different things from
scratch.
The course heavily relies on STM32CubeIDE as a dev environment (for good
reason) but that makes me wary on not being able to do things like write
drivers and deploy them onto the uC without it. Although I don't think it's
productive to resist this or push since I can't even imagine how I'd debug
without CubeIDE. It's got an insane amount of debugging and observability
features as well as the ability to terminate and relaunch programs on the
microcontroller from my host as I'm debugging so I can put in and remove debug
printfs or other breakpoints to observe the code.
