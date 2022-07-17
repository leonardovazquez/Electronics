Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=1.80
@EndOfDesignText@
#Region Module Attributes
	#FullScreen: False
	#IncludeTitle: True
#End Region

'Activity module
Sub Process_Globals
End Sub

Sub Globals
	Private cadena As String
	'Private btnLeerAD As Button
	'Private lblIdentificacion As Label
	Private btnID As Button
	'Private lblconvAD As Label
	'Private btnLED As ToggleButton
	'Private lblRDDI As Label
	'Private btnRDDI As Button

	Private btnCambiar As Button
	Private pnlSis As Panel
	'Private lblSis As Label
	'Private ToggleButton1 As ToggleButton
	'Private lblStatus As Label
	Private pnlID As Panel
	Private pnlTapa As Panel
	Private lblestTapa As Label
	Private lblTapa As Label
	Private pnlBomba As Panel
	Private lblBomba As Label
	Private lblStatusBomba As Label
	'Private ToggleButton2 As ToggleButton
	Private tbtManual As ToggleButton
	Private tbtAutomatico As ToggleButton
	Private pnUmb As Panel
	Private lblUmbrales As Label
	'Private sldUmbMinCrit As SeekBar
	'Private sldUmbMin As SeekBar
	'Private sldUmbSup As SeekBar
	'Private sldUmbSupCrit As SeekBar
	Private lblUmbInfCrit As Label
	Private lblUmbInf As Label
	Private lblUmbSup As Label
	Private lblUmbSupCrit As Label
	Private txtUmbInfCrit As EditText
	Private txtUmbInf As EditText
	Private txtUmbSup As EditText
	Private txtUmbSupCrit As EditText
	'Private btnCambumb As Button
	'Private btnReset As Button
	'Private pnlReg As Panel
'	Private btn_guardar As Button
'	Private btn_registro As Button
	Private pnlGrafico As Panel
	Private lblGrafico As Label
	Private lbllvl As Label
	'Private Gauge1 As Gauge
	Private nombre As String
	
	'Private txtStatus As EditText
	'Private lblStatus As Label
	Dim v11 As Int
	Dim v22 As Int
	Dim v33 As Int
	Dim v00 As Int
'	Dim v0 As Int
'	Dim v1 As Int
'	Dim v2 As Int
'	Dim v3 As Int
	'Private valores_string As String
	Private lblPeligro As Label
	Private comando As String
	Private txtID As EditText
	Private btnONOFF As ToggleButton
	
	
	Private tbtAutomatico As ToggleButton
	Private tbtManual As ToggleButton
	'Private Gauge1 As Gauge
	'Private WaterGauge1 As WaterGauge
	Private Consultar As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("2")
End Sub

Public Sub NewMessage (msg As String)
	cadena = cadena & msg
	Dim longitud As Int=cadena.Length
	If cadena.EndsWith(Chr(10)) Then
		If cadena.SubString2(0,2)="ID" Then
			nombre = cadena.SubString2(2,longitud-4)
			txtID.Text = nombre
		End If
		If cadena.SubString2(0,3)="UMB" Then
			v00 = cadena.SubString2(3,cadena.IndexOf(","))
			txtUmbInf.Text=NumberFormat(v00*100/1023,0,0)&"%"
			v11 = cadena.SubString2(cadena.IndexOf(",")+1,cadena.IndexOf(";"))
			txtUmbSup.Text=NumberFormat(v11*100/1023,0,0)&"%"
			v22 = cadena.SubString2(cadena.IndexOf(";")+1,cadena.IndexOf(":"))
			txtUmbInfCrit.Text=NumberFormat(v22*100/1023,0,0)&"%"
			v33 =cadena.SubString2(cadena.IndexOf(":")+1,longitud-2)
			txtUmbSupCrit.Text=NumberFormat(v33*100/1023,0,0)&"%"
		End If
		If cadena.SubString2(0,3)="SYS" Then
			If cadena.SubString2(3,4)=1 Then
				btnONOFF.Checked=True			
			Else If cadena.SubString2(3,4)=0 Then
				btnONOFF.Checked=False
			End If
		End If
		If cadena.SubString2(0,3)="MSG" Then
		
			Dim valores As Int = cadena.SubString2(5,longitud-2)
			lbllvl.Text =  NumberFormat(valores*100/1023,0,1) & "%"
			'valores_string = NumberFormat(valores*100/1023,0,1)
			
			'muestras_grf.Add(valores_string)
			'graficar(valores_string)
'			
			'Gauge2.Value=NumberFormat(valores*100/1023,0,1)
			If cadena.SubString2(5,longitud-2) <= v22 Then
				lblPeligro.Text= "Alerta! Nivel Crítico Mínimo"
			Else If cadena.SubString2(5,longitud-2) >= v33 Then
				lblPeligro.Text= "Alerta! Nivel Crítico Máximo"
			Else
				lblPeligro.Text= "Normal"
			End If
			If cadena.SubString2(4,5) =1 Then
				lblestTapa.Text= "ABIERTA"
				Dim s As String = "ALARM" & 1 
				Starter.Manager.SendMessage(s&Chr(10))
			Else
				lblestTapa.Text= "CERRADA"
				Dim s As String = "ALARM" & 0 
				Starter.Manager.SendMessage(s&Chr(10))
			End If
			If cadena.SubString2(3,4)=0 Then
				lblStatusBomba.Text="Apagada"
				
'				If (auto = 0) Then
'					cnvENGIN1.DrawCircle(cnvENGIN1.Height/2,cnvENGIN1.Height/2,cnvENGIN1.Height/2,fx.Colors.Red,True,1)
'					cnvENGIN2.DrawCircle(cnvENGIN2.Height/2,cnvENGIN2.Height/2,cnvENGIN2.Height/2,fx.Colors.DarkGray,True,1)
'				Else If (auto=1) Then
'					cnvENGIN1.DrawCircle(cnvENGIN1.Height/2,cnvENGIN1.Height/2,cnvENGIN1.Height/2,fx.Colors.DarkGray,True,1)
'					cnvENGIN2.DrawCircle(cnvENGIN2.Height/2,cnvENGIN2.Height/2,cnvENGIN2.Height/2,fx.Colors.Red,True,1)
'				End If
			Else If cadena.SubString2(3,4)=1 Then
				lblStatusBomba.Text="Encendida"
'				If (auto=0) Then
'					cnvENGIN1.DrawCircle(cnvENGIN1.Height/2,cnvENGIN1.Height/2,cnvENGIN1.Height/2,fx.Colors.Green,True,1)
'					cnvENGIN2.DrawCircle(cnvENGIN2.Height/2,cnvENGIN2.Height/2,cnvENGIN2.Height/2,fx.Colors.DarkGray,True,1)
'				Else If (auto=1) Then
'					cnvENGIN2.DrawCircle(cnvENGIN2.Height/2,cnvENGIN2.Height/2,cnvENGIN2.Height/2,fx.Colors.Green,True,1)
'					cnvENGIN1.DrawCircle(cnvENGIN1.Height/2,cnvENGIN1.Height/2,cnvENGIN1.Height/2,fx.Colors.DarkGray,True,1)
'				End If
			End If
			If cadena.SubString2(0,4)="MODE" Then
				Dim aux As Int = cadena.SubString2(4,5)
				If (aux=2) Then
					tbtAutomatico.Checked=True
					tbtManual.Checked=False
				Else If (aux=1) Then
					tbtManual.Checked=True
					tbtAutomatico.Checked= False
				Else If (aux=0) Then
					tbtManual.Checked=False
					tbtAutomatico.Checked= False
				End If
			End If
		End If
		cadena = ""
	End If
End Sub

Sub Activity_Resume
	UpdateState
End Sub

Public Sub UpdateState
	btnONOFF.Enabled = Starter.Manager.ConnectionState
	btnID.Enabled = Starter.Manager.ConnectionState
'	btnReset.Enabled=Starter.Manager.ConnectionState
	btnCambiar.Enabled=Starter.Manager.ConnectionState
	tbtManual.Enabled=Starter.Manager.ConnectionState
	tbtAutomatico.Enabled=Starter.Manager.ConnectionState
	Consultar.Enabled = Starter.Manager.ConnectionState
	
	'btnLED.Enabled = Starter.Manager.ConnectionState
	'btnRDDI.Enabled = Starter.Manager.ConnectionState
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	If UserClosed Then
		Starter.Manager.Disconnect
	End If
End Sub

Private Sub btnONOFF_CheckedChange(Checked As Boolean)
	If Checked Then
		Starter.Manager.SendMessage("ONOFF1"&Chr(10))
		Starter.Manager.SendMessage("THRQRY"&Chr(10))
		'lblStatus.Text="Encendido"
	Else
		Starter.Manager.SendMessage("ONOFF0"&Chr(10))
		'lblStatus.Text="Apagado"
	End If
	'Starter.Manager.SendMessage("ONOFF2"&Chr(10))
End Sub

Private Sub btnID_Click
	Starter.Manager.SendMessage("IDEN"&Chr(10))
End Sub


Private Sub btnCambiar_Click
	comando="ID2"
	Dim s As String = comando &"ID" & txtID.Text 
	Starter.Manager.SendMessage(s&Chr(10))
	comando="IDEN"
	Dim s As String = comando 
	Starter.Manager.SendMessage(s&Chr(10))
End Sub



'Private Sub btnCambumb_Click
'	v0 = NumberFormat(txtUmbInf*1023/100,0,0)
'	v1 = NumberFormat(txtUmbSup*1023/100,0,0)
'	v2 = NumberFormat(txtUmbInfCrit*1023/100,0,0)
'	v3 = NumberFormat(txtUmbSupCrit*1023/100,0,0)
'	Dim s As String = "CONFIG0" & v0 
'	Starter.Manager.SendMessage(s&Chr(10))
'	Dim s As String = "CONFIG1" & v1 
'	Starter.Manager.SendMessage(s&Chr(10))
'	Dim s As String = "CONFIG2" & v2 
'	Starter.Manager.SendMessage(s&Chr(10))
'	Dim s As String = "CONFIG3" & v3 
'	Starter.Manager.SendMessage(s&Chr(10))
'	Starter.Manager.SendMessage("THRQRY"&Chr(10))
'End Sub
'
'Private Sub btnReset_Click
'	Starter.Manager.SendMessage("THRRES"&Chr(10))
'	Starter.Manager.SendMessage("THRQRY"&Chr(10))
'End Sub

Private Sub tbtManual_CheckedChange(Checked As Boolean)
		If Checked Then
		Starter.Manager.SendMessage("ENGIN1"&Chr(10))
		tbtAutomatico.Checked = False
	Else
		Starter.Manager.SendMessage("ENGIN0"&Chr(10))
		tbtManual.Checked=False
		tbtAutomatico.Checked = False
	End If
End Sub

Private Sub tbtAutomatico_CheckedChange(Checked As Boolean)
		If Checked Then
		Starter.Manager.SendMessage("ENGIN2"&Chr(10))
		tbtManual.Checked=False
	Else
		Starter.Manager.SendMessage("ENGIN0"&Chr(10))
	End If
End Sub



Private Sub Consultar_Click
	Starter.Manager.SendMessage("THRQRY"&Chr(10))
End Sub