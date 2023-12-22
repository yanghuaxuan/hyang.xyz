---
title: "Adventures with Malloc"
date: 2023-12-21T14:34:30-08:00
draft: false
---

Recently, I have been cursed with a series of videos on my YouTube feed related to malloc. I've decided to dive deep into the malloc rabbit hole as well.

For those who don't know, to simply put, `malloc()`, and `free()`, is how C manages dynamic memory (memory that should be handled by the caller). `malloc()` simply allocates n bytes of dynamic memory, and returns a pointer to it. Unused dynamic memory should be freed by the caller with `free()`. You can read more about it [here](https://linux.die.net/man/3/malloc). 

Very simple concept! However, the implementation of malloc is far from simple...

To start, the heap is managed entirely by `malloc` and `free`. As a result, according to this [Wikipedia page](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation), there are 8 different well-known unique implementations of malloc. A notable one, [mimalloc](https://github.com/microsoft/mimalloc), claiming to the fastest, and small(?), is 8K LOC. For educational purposes, I've decided to to stick to the simplest implementation.


## Before the Heap
Program memory is divided into various segments: stack, heap, data, and text. As you
![Program Memory](images/memory.png)
