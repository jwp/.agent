"""
# Merge link records.
"""
import sys
from fault.system import process

def sequence(record, *, FS='\t', RS='\n'):
	"""
	# Construct a sequenced record for serialization.
	"""
	link, time, icon, title = record

	# Pad the timestamp for consistency.
	t = str(time)
	sub = t.rfind('.')
	pad = '0' * (10 - (len(t) - sub))

	return ''.join([
		link, FS,
		t + pad, FS,
		icon, FS,
		title, FS,
		RS,
	])

def structure(line, *, fields=4, FS='\t', RS='\n', tuple=tuple):
	"""
	# Construct a tuple of four fields from the given line.
	"""
	assert line[-1] == RS
	return tuple(line[:-1].split(FS, fields-1))

def merge(former, latter):
	"""
	# Merge the fields of identical links recognizing earlier time contexts
	# and non-empty fields as preferable.
	"""
	l, t, i, T = former
	assert l == latter[0]
	nd = 0

	if latter[1] < t:
		# Earliest timestamp wins.
		t = latter[1]
		nd += 1

	if latter[-1] and not T:
		# First non-empty title wins.
		T = latter[-1]
		nd += 1
	if not i and latter[2]:
		# First non-empty icon wins.
		i = latter[2]
		nd += 1

	if nd:
		return (l, t, i, T)
	else:
		# Avoid reconstruction when fields have not been changed.
		return former

def processor(records):
	"""
	# Merge duplicate link records; presumes &records is sorted.
	"""

	# Initial state that will be immediately overwritten by &merge.
	i = iter(records)
	try:
		y = next(i)
	except StopIteration:
		return

	for r in i:
		if r[0] == y[0]:
			y = merge(y, r)
		else:
			yield y
			y = r
	else:
		# Last one.
		yield y

def main(inv:process.Invocation) -> process.Exit:
	records = map(structure, sys.stdin.readlines())
	sys.stdout.writelines(map(sequence, processor(records)))
	return inv.exit(0)
