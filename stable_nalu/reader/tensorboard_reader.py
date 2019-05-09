
import os
import os.path as path
import tensorflow as tf

def _listdir_filter_hidden_files(dirpath):
    files = os.listdir(dirpath)
    files = filter(lambda filename: filename[0] != '.', files)
    return list(files)

class TensorboardReader:
    """Reads the final values (before reaching NaN) from a directory of
    of results
    """

    def __init__(self, dirpath):
        self._sourcedir = dirpath
        self._directories = _listdir_filter_hidden_files(dirpath)

    def __iter__(self):
        """Return the last non-nan result from each directory.

        The format is (dirname, losses, last_global_step)
        """
        for subdir in self._directories:
            logfiles = _listdir_filter_hidden_files(path.join(self._sourcedir, subdir))
            if len(logfiles) > 1:
                raise Exception(f'more than one logfile was found in {subdir}')

            reader = tf.train.summary_iterator(path.join(self._sourcedir, subdir, logfiles[0]))
            yield (subdir, reader)

    def __len__(self):
        return len(self._directories)