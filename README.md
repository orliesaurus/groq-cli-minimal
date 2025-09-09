# groq-cli-minimal

A minimal CLI tool to interact with Groq's AI models directly from your terminal. Stream responses to prompts, making it useful for quick AI queries, coding assistance, and more.

## Features

- Stream responses from Groq AI models
- Simple bash script with minimal dependencies
- Supports custom prompts with special characters (question marks, quotes, etc.)
- Configurable model and parameters
- Error handling for API failures

## Prerequisites

- Bash shell
- `curl` (for HTTP requests)
- `jq` (for JSON parsing)
- A Groq API key (get one from [Groq Console](https://console.groq.com/))

## Installation

1. Clone or download this repository:

   ```bash
   git clone https://github.com/orliesaurus/groq-cli-minimal.git
   cd groq-cli-minimal
   ```

2. Make the script executable:
   ```bash
   chmod +x groqcli.sh
   ```

## Setup

1. Obtain your Groq API key from the [Groq Console](https://console.groq.com/).

2. Set the `GROQ_API_KEY` environment variable:

   ```bash
   export GROQ_API_KEY="your-api-key-here"
   ```

   Add this to your shell profile (e.g., `~/.bashrc`, `~/.zshrc`) for persistence:

   ```bash
   echo 'export GROQ_API_KEY="your-api-key-here"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. ⚡ Highly Recommended bu totally Optional ⚡
   Create an alias for easier usage:
   ```bash
   alias ask='noglob /Users/orlie/Projects/groq-cli-minimal/groqcli.sh'
   ```
   Add this to your `~/.zshrc` to make it permanent.

## Usage

### Basic Usage

Run the script with a prompt:

```bash
./groqcli.sh "What is the capital of France?"
```

Or with the alias:

```bash
ask "What is the capital of France?"
```

### Advanced mode: handling Special Characters

Since the alias uses `noglob`, you can include question marks and other special characters without shell expansion errors:

```bash
ask hello who are you?
```

BUT: For prompts with spaces or quotes, use double quotes:

```bash
ask "hello what's the best way to write C?"
```

### Configuration

Edit the script to change settings:

- **Model**: Change the `MODEL` variable (default: `openai/gpt-oss-20b`)
- **System Prompt**: Modify the system message in the JSON payload
- **Other Parameters**: Adjust temperature, max tokens, etc.

## Examples

```bash
# Simple question
ask Explain recursion in programming

# Coding query
ask Write a Python function to reverse a string

# Technical command
ask How to list files in a directory on Linux?
```

## Troubleshooting

- **"GROQ_API_KEY environment variable not set"**: Ensure you've set the API key as described in Setup.
- **"Failed to connect to Groq API"**: Check your internet connection and API key validity.
- **Globbing errors**: Use the `noglob` alias or quote your prompts.
- **jq not found**: Install jq: `brew install jq` (macOS) or `sudo apt install jq` (Ubuntu).

## License

This project is licensed under the terms in the [LICENSE](LICENSE) file.

## Contributing

Feel free to open issues or submit pull requests for improvements!
