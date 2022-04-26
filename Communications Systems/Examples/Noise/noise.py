#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Noise Study
# Author: Vazquez Leonardo
# GNU Radio version: 3.10.1.1

from packaging.version import Version as StrictVersion

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()")

from PyQt5 import Qt
from gnuradio import eng_notation
from gnuradio import blocks
from gnuradio import digital
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx



from gnuradio import qtgui

class noise(gr.top_block, Qt.QWidget):

    def __init__(self):
        gr.top_block.__init__(self, "Noise Study", catch_exceptions=True)
        Qt.QWidget.__init__(self)
        self.setWindowTitle("Noise Study")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "noise")

        try:
            if StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
                self.restoreGeometry(self.settings.value("geometry").toByteArray())
            else:
                self.restoreGeometry(self.settings.value("geometry"))
        except:
            pass

        ##################################################
        # Variables
        ##################################################
        self.variable_header_format_default_0 = variable_header_format_default_0 = digital.header_format_default(digital.packet_utils.default_access_code,0, 1)
        self.samp_rate = samp_rate = 3200
        self.noise_amp = noise_amp = 1

        ##################################################
        # Blocks
        ##################################################
        self._noise_amp_tool_bar = Qt.QToolBar(self)
        self._noise_amp_tool_bar.addWidget(Qt.QLabel("Noise amplitude" + ": "))
        self._noise_amp_line_edit = Qt.QLineEdit(str(self.noise_amp))
        self._noise_amp_tool_bar.addWidget(self._noise_amp_line_edit)
        self._noise_amp_line_edit.returnPressed.connect(
            lambda: self.set_noise_amp(eng_notation.str_to_num(str(self._noise_amp_line_edit.text()))))
        self.top_layout.addWidget(self._noise_amp_tool_bar)
        self.digital_crc32_bb_0 = digital.crc32_bb(False, 'variable_header_format_default_0', True)
        self.blocks_vector_to_stream_1 = blocks.vector_to_stream(gr.sizeof_gr_complex*1, 1)
        self.blocks_vector_source_x_0 = blocks.vector_source_c((1,1,1), False, 1, [])
        self.blocks_file_sink_0_0 = blocks.file_sink(gr.sizeof_char*1, '/home/leonardo/Desktop/FACULTAD/TESIS/GNU RADIO/Examples/Noise/Re.py', False)
        self.blocks_file_sink_0_0.set_unbuffered(True)
        self.blocks_complex_to_interleaved_char_0 = blocks.complex_to_interleaved_char(False, 1.0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_complex_to_interleaved_char_0, 0), (self.digital_crc32_bb_0, 0))
        self.connect((self.blocks_vector_source_x_0, 0), (self.blocks_vector_to_stream_1, 0))
        self.connect((self.blocks_vector_to_stream_1, 0), (self.blocks_complex_to_interleaved_char_0, 0))
        self.connect((self.digital_crc32_bb_0, 0), (self.blocks_file_sink_0_0, 0))


    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "noise")
        self.settings.setValue("geometry", self.saveGeometry())
        self.stop()
        self.wait()

        event.accept()

    def get_variable_header_format_default_0(self):
        return self.variable_header_format_default_0

    def set_variable_header_format_default_0(self, variable_header_format_default_0):
        self.variable_header_format_default_0 = variable_header_format_default_0

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate

    def get_noise_amp(self):
        return self.noise_amp

    def set_noise_amp(self, noise_amp):
        self.noise_amp = noise_amp
        Qt.QMetaObject.invokeMethod(self._noise_amp_line_edit, "setText", Qt.Q_ARG("QString", eng_notation.num_to_str(self.noise_amp)))




def main(top_block_cls=noise, options=None):

    if StrictVersion("4.5.0") <= StrictVersion(Qt.qVersion()) < StrictVersion("5.0.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls()

    tb.start()

    tb.show()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        Qt.QApplication.quit()

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    timer = Qt.QTimer()
    timer.start(500)
    timer.timeout.connect(lambda: None)

    qapp.exec_()

if __name__ == '__main__':
    main()
