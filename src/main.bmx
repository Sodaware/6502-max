' ------------------------------------------------------------------------------
' -- src/main.bmx
' --
' -- Main driver file for the 6502 simulator.
' --
' -- There are two main parts to this project. Files in "core" handle the
' -- behind-the-scenes part of the simulator. Opcodes, memory management and
' -- CPU simulation are all part of core.
' --
' -- The graphical interface for the simulator is found in "frontend".
' --
' -- This file is part of "6502-max" (https://www.sodaware.net/6502-max/)
' -- Copyright (c) 2018-2019 Phil Newton
' --
' -- 6502-max is free software; you can redistribute it and/or modify
' -- it under the terms of the GNU General Public License as published by
' -- the Free Software Foundation; either version 3 of the License, or
' -- (at your option) any later version.
' --
' -- 6502-max is distributed in the hope that it will be useful,
' -- but WITHOUT ANY WARRANTY; without even the implied warranty of
' -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' -- GNU General Public License for more details.
' --
' -- You should have received a copy of the GNU General Public
' -- License along with 6502-max (see the file COPYING for more details);
' -- If not, see <http://www.gnu.org/licenses/>.
' ------------------------------------------------------------------------------


SuperStrict

Framework brl.basic
Import brl.retro

Import "frontend/app.bmx"

Local theApp:App = New App
theApp.run()
