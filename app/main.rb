def tick args
  # Initialisierung (nur beim ersten Aufruf)
  args.state.ball ||= { x: 640, y: 360, w: 20, h: 20, dx: 10, dy: 6 }  # Centered and larger ball
  args.state.left_paddle ||= { x: 50, y: 340, w: 20, h: 100 }          # Larger paddle, moved from edge
  args.state.right_paddle ||= { x: 1210, y: 340, w: 20, h: 100 }       # Larger paddle, moved from edge

  # Ballbewegung
  args.state.ball.x += args.state.ball.dx
  args.state.ball.y += args.state.ball.dy

  # Kollisionserkennung mit den Wänden
  if args.state.ball.y < 0 || args.state.ball.y + args.state.ball.h > 720  # Updated height boundary
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
    args.state.ball.x = 640                # Reset to center X
    args.state.ball.y = 360                # Reset to center Y
  elsif args.state.ball.x + args.state.ball.w > 1280  # Updated width boundary
    args.state.left_score ||= 0
    args.state.left_score += 1
    args.state.ball.x = 640                # Reset to center X
    args.state.ball.y = 360                # Reset to center Y
  end

  # Steuerung der Schläger
  # Left paddle control (W and S keys)
  if args.inputs.keyboard.key_held.w
    args.state.left_paddle.y += 10         # Faster paddle movement
  elsif args.inputs.keyboard.key_held.s
    args.state.left_paddle.y -= 10         # Faster paddle movement
  end

  if args.inputs.keyboard.key_held.up
    args.state.right_paddle.y += 10        # Faster paddle movement
  elsif args.inputs.keyboard.key_held.down
    args.state.right_paddle.y -= 10        # Faster paddle movement
  end

  # Keep paddles within screen bounds
  args.state.left_paddle.y = args.state.left_paddle.y.clamp(0, 720 - args.state.left_paddle.h)
  args.state.right_paddle.y = args.state.right_paddle.y.clamp(0, 720 - args.state.right_paddle.h)

  # Zeichnen
  args.outputs.solids << args.state.ball
  args.outputs.solids << args.state.left_paddle
  args.outputs.solids << args.state.right_paddle

  # Anzeige des Punktestands (larger text and repositioned)
  args.outputs.labels << { 
    x: 540, 
    y: 650, 
    text: args.state.left_score.to_s,
    size_px: 50,                           # Larger text size
    alignment_enum: 1                      # Center aligned
  }
  
  args.outputs.labels << { 
    x: 740, 
    y: 650, 
    text: args.state.right_score.to_s,
    size_px: 50,                           # Larger text size
    alignment_enum: 1                      # Center aligned
  }
end
