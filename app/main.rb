def tick args
  # Initialisierung (nur beim ersten Aufruf)
  args.state.ball ||= { x: 300, y: 200, w: 10, h: 10, dx: 5, dy: 3 }
  args.state.left_paddle ||= { x: 10, y: 180, w: 10, h: 40 }
  args.state.right_paddle ||= { x: 590, y: 180, w: 10, h: 40 }

  # Ballbewegung
  args.state.ball.x += args.state.ball.dx
  args.state.ball.y += args.state.ball.dy

  # Kollisionserkennung mit den Wänden
  if args.state.ball.y < 0 || args.state.ball.y + args.state.ball.h > 400
    args.state.ball.dy = -args.state.ball.dy 
  end

  # Kollisionserkennung mit den Schlägern
  if args.state.ball.intersect_rect? args.state.left_paddle
    args.state.ball.dx = -args.state.ball.dx
  elsif args.state.ball.intersect_rect? args.state.right_paddle
    args.state.ball.dx = -args.state.ball.dx
  end

  # Punktvergabe, wenn der Ball die linke oder rechte Seite erreicht
  if args.state.ball.x < 0
    args.state.right_score ||= 0
    args.state.right_score += 1
    args.state.ball.x = 300
    args.state.ball.y = 200
  elsif args.state.ball.x + args.state.ball.w > 600
    args.state.left_score ||= 0
    args.state.left_score += 1
    args.state.ball.x = 300
    args.state.ball.y = 200
  end

  # Steuerung der Schläger
  if args.inputs.keyboard.w 
    args.state.left_paddle.y += 5
  elsif args.inputs.keyboard.s
    args.state.left_paddle.y -= 5
  end

  if args.inputs.keyboard.up
    args.state.right_paddle.y += 5
  elsif args.inputs.keyboard.down
    args.state.right_paddle.y -= 5
  end

  # Zeichnen
  args.outputs.solids << args.state.ball
  args.outputs.solids << args.state.left_paddle
  args.outputs.solids << args.state.right_paddle

  # Anzeige des Punktestands
  args.outputs.labels << { x: 250, y: 350, text: args.state.left_score.to_s }
  args.outputs.labels << { x: 350, y: 350, text: args.state.right_score.to_s }
end
