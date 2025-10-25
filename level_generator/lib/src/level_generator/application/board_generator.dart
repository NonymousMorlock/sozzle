import 'dart:math';

/// Utility class for generating word search puzzle boards
class BoardGenerator {
  BoardGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;
  static const _directions = [
    // Horizontal
    [0, 1],
    // Vertical
    [1, 0],
    // Diagonal down-right
    [1, 1],
    // Diagonal up-right
    [-1, 1],
  ];

  /// Generates a board with the given words placed randomly.
  /// Returns a tuple of (boardData, width, height).
  (List<String> board, int width, int height) generateBoard(List<String> words) {
    // Sort words by length (longest first)
    words.sort((a, b) => b.length.compareTo(a.length));

    // Calculate minimum board dimensions
    var maxLength = words.fold(0, (max, word) => word.length > max ? word.length : max);
    var minSize = maxLength + 2; // Add buffer space
    var width = minSize;
    var height = minSize;

    // Keep trying until we succeed or exceed max attempts
    var maxAttempts = 10;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      var board = List.filled(width * height, '');
      var success = true;

      // Try to place each word
      for (var word in words) {
        var placed = false;
        var wordTries = 20; // Attempts per word

        while (!placed && wordTries > 0) {
          // Pick random direction and starting point
          var dir = _directions[_random.nextInt(_directions.length)];
          var startX = _random.nextInt(width);
          var startY = _random.nextInt(height);

          // Check if word fits at this position and direction
          if (_canPlaceWord(board, word, startX, startY, dir[0], dir[1], width, height)) {
            _placeWord(board, word, startX, startY, dir[0], dir[1], width);
            placed = true;
          }
          wordTries--;
        }

        if (!placed) {
          success = false;
          break;
        }
      }

      if (success) {
        // Fill empty spaces with random letters
        for (var i = 0; i < board.length; i++) {
          if (board[i].isEmpty) {
            board[i] = String.fromCharCode(_random.nextInt(26) + 65); // A-Z
          }
        }
        return (board, width, height);
      }

      // If failed, try with larger board
      width += 1;
      height += 1;
    }

    throw Exception('Failed to generate board after $maxAttempts attempts');
  }

  bool _canPlaceWord(
    List<String> board,
    String word,
    int startX,
    int startY,
    int dirX,
    int dirY,
    int width,
    int height,
  ) {
    var x = startX;
    var y = startY;

    for (var i = 0; i < word.length; i++) {
      if (x < 0 || x >= width || y < 0 || y >= height) {
        return false;
      }

      var cell = board[y * width + x];
      if (cell.isNotEmpty && cell != word[i]) {
        return false;
      }

      x += dirX;
      y += dirY;
    }

    return true;
  }

  void _placeWord(
    List<String> board,
    String word,
    int startX,
    int startY,
    int dirX,
    int dirY,
    int width,
  ) {
    var x = startX;
    var y = startY;

    for (var i = 0; i < word.length; i++) {
      board[y * width + x] = word[i];
      x += dirX;
      y += dirY;
    }
  }
}