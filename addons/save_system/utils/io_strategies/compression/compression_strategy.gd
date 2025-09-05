extends RefCounted

## Abstract method to compress byte data.
func compress(bytes: PackedByteArray) -> PackedByteArray:
	push_error("CompressionStrategy.compress() must be implemented by subclasses.")
	return PackedByteArray()

## Abstract method to decompress byte data.
func decompress(bytes: PackedByteArray) -> PackedByteArray:
	push_error("CompressionStrategy.decompress() must be implemented by subclasses.")
	return PackedByteArray() 
