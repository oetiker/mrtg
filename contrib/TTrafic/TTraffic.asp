<%
'*******************************************************************************
'*                                                                             *
'* TTraffic 1.0.0 (distributed under GNU GENERAL PUBLIC LICENSE)              *
'* by kamborio                                                                 *
'*                                                                             *
'* ------------------------------------------------------                      *
'*  _                       _                   _                              *
'* | | __  __ _  _ __ ___  | |__    ___   _ __ (_)  ___                        *
'* | |/ / / _` || '_ ` _ \ | '_ \  / _ \ | '__|| | / _ \                       *
'* |   < | (_| || | | | | || |_) || (_) || |   | || (_) |                      *
'* |_|\_\ \__,_||_| |_| |_||_.__/  \___/ |_|   |_| \___/                       *
'* ------------------------------------------------------                      *
'*                               http://www.kamborio.com/                      *
'*                                                                             *
'* Copyright (C) 2001 David A. Pérez (david@kamborio.com)                      *
'*                                                                             *
'* This program is free software; you can redistribute it and/or modify it     *
'* under the terms of the GNU General Public License as published by the Free  *
'* Software Foundation; either version 2 of the License, or (at your option)   *
'* any later version.                                                          *
'*                                                                             *
'* This program is distributed in the hope that it will be useful, but WITHOUT *
'* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or       *
'* FITNESS FOR A  PARTICULAR PURPOSE. See the GNU General Public License for   *
'* more details.                                                               *
'*                                                                             *
'* You should have received a copy of the GNU General Public License along     *
'* with this program; if not, write to the:                                    *
'*                                                                             *
'* Free Software Foundation, Inc.                                              *
'* 59 Temple Place - Suite 330                                                 *
'* Boston, MA 02111-1307, USA                                                  *
'*                                                                             *
'*******************************************************************************

Const ForReading = 1, ForWriting = 2

Dim LogsMode

LogsMode = 1

Dim Order, Period
Dim fso, f, p, n, TheFile, LineNumber, TheLine, TheValues
Dim ReadAt, LastRan, TotalBytesIn, TotalBytesOut
Dim PeriodIn, PeriodOut, MonthIn, MonthOut

Period = Request("Period")
Order = Trim(CStr(Request("Order")))

If Not IsNumeric(Period) Then
	Period = 30
Else
	If Period < 1 Then
		Period = 30
	End If
End If

If Order = "" Then
	Order = "G"
End If

Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.GetFile(Request.ServerVariables("PATH_TRANSLATED"))

If LogsMode = 1 Then

	ReDim p(0)

	p(0) = Replace(f.Name, ".asp", "") & ".log"

Else

	p = Split(f.Path, "\")

	For n = 1 To (UBound(p) - 2)
		p(0) = p(0) & "\" & p(n)
	Next

	p(0) = p(0) & "\logs\" & p(n) & "\" & Replace(f.Name, ".asp", "") & ".log"

End If

Set TheFile = fso.OpenTextFile(p(0), ForReading)

LineNumber = -1

While Not TheFile.AtEndOfStream

	LineNumber = LineNumber + 1

	TheLine = TheFile.ReadLine

	TheValues = Split(TheLine)

	If LineNumber = 0 Then
		LastRan = UNIXToDay(TheValues(0))
		TotalBytesIn = CDbl(TheValues(1))
		TotalBytesOut = CDbl(TheValues(2))
	Else
		If DateDiff("d", UNIXToDay(TheValues(0)), Now) < CLng(Period) Then
			PeriodIn = PeriodIn + CDbl(TheValues(1) * (ReadAt - TheValues(0)))
			PeriodOut = PeriodOut + CDbl(TheValues(2) * (ReadAt - TheValues(0)))
		End If

		If Month(UNIXToDay(TheValues(0))) = Month(Now) And Year(UNIXToDay(TheValues(0))) = Year(Now) Then
			MonthIn = MonthIn + CDbl(TheValues(1) * (ReadAt - TheValues(0)))
			MonthOut = MonthOut + CDbl(TheValues(2) * (ReadAt - TheValues(0)))
		End If

	End If

	ReadAt = TheValues(0)

Wend

Set TheFile = Nothing
set f = Nothing
Set fso = Nothing

Response.Write "<HR><BR>"
Response.Write "<TABLE><TR><TD>Interface:</TD>"
Response.Write "<TD>" & BytesTo(TotalBytesIn, Order) & " In and " & BytesTo(TotalBytesOut, Order) & " Out</B>, making a total of " & BytesTo((TotalBytesIn + TotalBytesOut), Order) & "</TD></TR>"
Response.Write "<TR><TD>" & MonthName(Month(Now)) & ":</TD>"
Response.Write "<TD>" & BytesTo(MonthIn, Order) & " In and " & BytesTo(MonthOut, Order) & " Out, making a total of " & BytesTo((MonthIn + MonthOut), Order) & "</TD></TR>"
Response.Write "<TR><TD>Last " & Period & " days:</TD>"
Response.Write "<TD>" & BytesTo(PeriodIn, Order) & " In and " & BytesTo(PeriodOut, Order) & " Out, making a total of " & BytesTo((PeriodIn + PeriodOut), Order) & "</TD></TR></TABLE>"



Function UNIXToDay(Value)

	UNIXToDay = DateAdd("s", Value, "1/Jan/1970 0:00")

End Function

Function BytesTo(Value, Order)

	Dim NumericalOrder, OrderName

	Select Case UCase(Order)
		Case "K"
			NumericalOrder = "1"
			OrderName = "Kb"
		Case "M"
			NumericalOrder = "2"
			OrderName = "Mb"
		Case "G"
			NumericalOrder = "3"
			OrderName = "Gb"
		Case "T"
			NumericalOrder = "4"
			OrderName = "Tb"
		Case "P"
			NumericalOrder = "5"
			OrderName = "Pb"
		Case Else
			NumericalOrder = "0"
			OrderName = "Bytes"
	End Select

	BytesTo = Round((Value / 1024 ^ NumericalOrder), 2) & " " & OrderName

End Function
%>