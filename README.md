# autorip

This is a simple script to automate the process of archiving DVDs.

Provided a device (e.g. `/dev/dvd0`)
and an output directory, this will attempt to parse the name of the disk and create relevant
folders (e.g. `output_dir/show_name/season/`, or `output_dir/movie_name`), and create a `.iso` file by copying
the disk using `dd`. When the copy is completed, the disk will be ejected, and a [bell](https://en.wikipedia.org/wiki/Bell_character)
will sound, indicating the script is ready for the next disk - once the drive is closed, the process will
continue with the new disk.

# Notes

Some disks may have copy protection features that will present bad bytes, which can cause errors with `dd`.
If `dd` fails to copy the disk, `dddrescue` will be used, which, while slower than `dd`, is more capable of
ignoring the bad bytes. `dd` likely comes on your system by default, but `ddrescue` will need to be installed
manually.

# Disclaimer

Please see the license, and note that this is provided freely in the hopes that it will be useful, but without
any warranty, or guarantee that it will work, or be free of bugs.

This is intended for making archive (backup) copies of media that has been legally obtained. Depending on what
you are archiving, and where you reside, sharing the resulting files may break copyright (or other) laws. The decision of
whether to respect said laws is up to the user; I am not responsible for how you use this script, or
what you do with the files. It should also be noted that certain cloud backup services may inspect your files,
and suspend/revoke your account, if they suspect you are uploading copyrighted material. This may happen without
warning, and you may lose access to all of your data. Please read the laws of the jurisdiction in which you reside, and
terms of any cloud services you use. Again, I am not responsible for any losses or legal issues incurred by using the script, or
transmitting, uploading, storing, sharing, etc the resulting files.

# Usage

```
autorip.sh /path/to/disk/device /path/to/output/folder
```
