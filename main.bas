_Title "Retro Dodge"
Screen 13
Randomize Timer

Do
    Dim startGame As Integer
    startGame = 0
    Do While startGame = 0
        Cls
        Color 14
        Locate 10, 12
        Print "RETRO DODGE"
        Locate 12, 10
        Print "PRESS ANY KEY TO START!"
        k$ = InKey$
        If k$ <> "" Then startGame = 1
        _Limit 60
    Loop

    Dim px As Integer, py As Integer
    Dim bx(1 To 10) As Integer, by(1 To 10) As Integer
    Dim activeBalls As Integer, score As Integer, speed As Single
    Dim noteTimer As Single, noteIndex As Integer
    Dim notes(1 To 8) As Integer
    Dim lastPlayerX As Integer
    Dim gameOver As Integer
    Dim secretEnding As Integer


    Dim confX(1 To 50) As Integer, confY(1 To 50) As Integer
    Dim confColor(1 To 50) As Integer
    Dim i As Integer
    For i = 1 To 50
        confX(i) = Int(Rnd * 320)
        confY(i) = Int(Rnd * 200)
        confColor(i) = Int(Rnd * 15) + 1
    Next

    px = 160: py = 180
    speed = 2.5
    score = 0
    activeBalls = 1
    lastPlayerX = px
    gameOver = 0
    secretEnding = 0

    For i = 1 To 10
        bx(i) = Int(Rnd * 310) + 5
        by(i) = -Int(Rnd * 100)
    Next

    ' background music
    notes(1) = 400: notes(2) = 500: notes(3) = 450: notes(4) = 600
    notes(5) = 400: notes(6) = 800: notes(7) = 500: notes(8) = 900
    noteTimer = Timer: noteIndex = 1

    Do
        Cls

        ' player
        Line (px - 5, py - 5)-(px + 5, py + 5), 10, BF


        If gameOver = 0 And secretEnding = 0 Then
            For i = 1 To activeBalls
                by(i) = by(i) + speed
                Line (bx(i) - 4, by(i) - 4)-(bx(i) + 4, by(i) + 4), 12, BF

                If Abs(px - bx(i)) < 6 And Abs(py - by(i)) < 6 Then
                    gameOver = 1
                    For j = 1 To 3
                        Cls
                        Color 12
                        Print "GAME OVER!"
                        _Limit 5
                        Cls
                        _Limit 5
                    Next
                    Sound 220, 10
                    Sound 150, 15
                End If
            Next

            If by(1) > 200 Then
                lastPlayerX = px
                For i = 1 To activeBalls
                    by(i) = -10
                    If i = 1 Then
                        bx(i) = lastPlayerX
                    Else
                        Do
                            bx(i) = Int(Rnd * 310) + 5
                        Loop While Abs(bx(i) - bx(1)) < 20 Or (activeBalls >= 3 And i = 3 And Abs(bx(i) - bx(2)) < 20)
                    End If
                Next

                score = score + 1
                Sound 1200, 5

                If score Mod 3 = 0 Then speed = speed + 0.2

                If score Mod 10 = 0 And activeBalls < 10 Then activeBalls = activeBalls + 1
            End If
        End If

        k$ = InKey$
        If (k$ = "a" Or k$ = "A") And gameOver = 0 Then px = px - 4
        If (k$ = "d" Or k$ = "D") And gameOver = 0 Then px = px + 4
        If px < 5 Then px = 5
        If px > 315 Then px = 315

        If Timer - noteTimer > 0.25 And secretEnding = 0 Then
            Sound notes(noteIndex), 3
            noteIndex = noteIndex + 1
            If noteIndex > 8 Then noteIndex = 1
            noteTimer = Timer
        End If

        Color 15
        Locate 1, 1
        Print "SCORE: "; score

        If gameOver = 1 Then
            k$ = ""
            Do
                Locate 12, 10
                Color 12
                Print "PRESS ENTER TO RETURN TO MAIN MENU!"
                k$ = InKey$
                _Limit 60
            Loop Until k$ = Chr$(13)
            Exit Do
        End If

        If score >= 500 And secretEnding = 0 Then
            secretEnding = 1
            Do
                Cls
                Color 14
                Locate 5, 10
                Print "YOU WIN! CONGRATULATIONS, PLAYER!"

                Line (120, 120)-(200, 160), 6, BF 
                Line (120, 100)-(200, 120), 7, BF 
                Circle (160, 95), 3, 4 

                For i = 1 To 50
                    Color confColor(i)
                    Line (confX(i), confY(i))-(confX(i) + 2, confY(i) + 4), confColor(i), BF
                    confY(i) = confY(i) + 2
                    If confY(i) > 200 Then confY(i) = 0: confX(i) = Int(Rnd * 320)
                Next

                Locate 15, 10
                Print "PRESS ENTER TO RESTART!"

                If Timer - noteTimer > 0.25 Then
                    Sound 800, 5
                    Sound 1000, 5
                    Sound 1200, 5
                    Sound 1400, 5
                    Sound 1600, 5
                    Sound 1800, 5
                    noteTimer = Timer + 10
                End If

                k$ = InKey$
                If k$ = Chr$(13) Then Exit Do
                _Limit 75
            Loop
        End If

        _Limit 75
    Loop
Loop

