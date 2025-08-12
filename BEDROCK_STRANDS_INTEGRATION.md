# Amazon Bedrock AgentCore & Strands Agents Integration with Windsurf

This guide shows you how to integrate Amazon Bedrock AgentCore and Strands Agents with Windsurf IDE for enhanced AI-powered development workflows.

## 🎯 **Recommended Approach: Separate Repository**

Create a dedicated repository for your AI agents to maintain clean separation and enable reusability across projects.

## 🚀 **Quick Setup**

### **Step 1: Create New Repository for Agents**

```bash
# Create new directory for your AI agents
mkdir my-windsurf-agents
cd my-windsurf-agents

# Initialize git repository
git init
git remote add origin https://github.com/yourusername/my-windsurf-agents.git
```

### **Step 2: Set Up Python Environment**

```bash
# Create virtual environment
python -m venv .venv

# Activate virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### **Step 3: Configure AWS Credentials**

```bash
# Option 1: AWS CLI configuration
aws configure

# Option 2: Environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1
```

### **Step 4: Enable Bedrock Model Access**

1. Go to AWS Console → Amazon Bedrock
2. Navigate to **Model access** in the left sidebar
3. Click **Request model access**
4. Enable access for:
   - **Anthropic Claude 3.5 Sonnet**
   - **Anthropic Claude 3 Haiku** (for faster responses)

## 📁 **Repository Structure**

```
my-windsurf-agents/
├── agents/
│   ├── __init__.py
│   ├── bedrock_agent.py          # Bedrock AgentCore integration
│   ├── strands_agent.py          # Strands Agents integration
│   └── windsurf_agent.py         # Combined Windsurf-optimized agent
├── tools/
│   ├── __init__.py
│   ├── code_analyzer.py          # Code analysis tools
│   ├── aws_helper.py             # AWS architecture suggestions
│   └── documentation_generator.py # Auto-documentation tools
├── examples/
│   ├── basic_usage.py
│   ├── code_review_example.py
│   └── architecture_design.py
├── tests/
│   ├── test_bedrock_agent.py
│   └── test_strands_agent.py
├── requirements.txt
├── .env.example
├── README.md
└── setup.py
```

## 🔧 **Integration Options**

### **Option 1: Use as Python Package (Recommended)**

Install your agents as a package in any Windsurf project:

```bash
# In your Windsurf project
pip install git+https://github.com/yourusername/my-windsurf-agents.git

# Or for local development
pip install -e /path/to/my-windsurf-agents
```

**Usage in Windsurf projects:**
```python
from agents import WindsurfBedrockAgent, WindsurfStrandsAgent

# Initialize agents
bedrock_agent = WindsurfBedrockAgent(region="us-east-1")
strands_agent = WindsurfStrandsAgent()

# Use for code analysis
analysis = bedrock_agent.analyze_code(your_code, "python")
print(analysis)
```

### **Option 2: Git Submodule**

Add your agents repository as a submodule:

```bash
# In your Windsurf project
git submodule add https://github.com/yourusername/my-windsurf-agents.git agents
git submodule update --init --recursive
```

### **Option 3: Direct Integration**

Copy agent files directly into your project (less recommended):

```bash
# Copy agents to your project
cp -r /path/to/my-windsurf-agents/agents ./
pip install -r agents/requirements.txt
```

## 🛠️ **Framework Comparison**

| Feature | Bedrock AgentCore | Strands Agents |
|---------|-------------------|----------------|
| **Hosting** | Fully managed AWS service | Self-hosted or AWS deployment |
| **Models** | Bedrock models only | Any LLM provider |
| **Scalability** | Auto-scaling, serverless | Manual scaling required |
| **Memory** | Built-in persistent memory | Custom memory implementation |
| **Tools** | AWS-native tools | Extensive tool ecosystem |
| **Cost** | Pay-per-use | Infrastructure + model costs |
| **Setup** | AWS account required | More flexible deployment |

## 🎨 **Usage Examples**

### **Code Review Assistant**

```python
from agents import WindsurfBedrockAgent

agent = WindsurfBedrockAgent()

# Analyze code for issues
code = """
def process_data(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result
"""

review = agent.analyze_code(code, "python")
print(review)
```

### **AWS Architecture Advisor**

```python
requirements = """
Need a web app that:
- Handles 50k concurrent users
- Processes real-time chat
- Stores user profiles
- Sends push notifications
"""

architecture = agent.suggest_aws_architecture(requirements)
print(architecture)
```

### **Multi-Agent Workflow**

```python
from agents import WindsurfStrandsAgent

# Create specialized agents
code_agent = WindsurfStrandsAgent(
    tools=["code_analyzer", "debugger"],
    specialization="code_review"
)

architecture_agent = WindsurfStrandsAgent(
    tools=["aws_helper", "diagram_generator"],
    specialization="system_design"
)

# Collaborative workflow
code_analysis = code_agent.analyze("your_code.py")
architecture_suggestions = architecture_agent.design(code_analysis)
```

## 🔐 **Security Best Practices**

### **Environment Variables**

Create `.env` file (never commit this):
```bash
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_DEFAULT_REGION=us-east-1
OPENAI_API_KEY=your_openai_key  # If using OpenAI
ANTHROPIC_API_KEY=your_anthropic_key  # If using Anthropic directly
```

### **IAM Permissions**

Minimum required permissions for Bedrock:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream",
                "bedrock:CreateAgent",
                "bedrock:GetAgent",
                "bedrock:ListAgents"
            ],
            "Resource": "*"
        }
    ]
}
```

## 🚀 **Deployment Options**

### **Local Development**
- Run agents directly in Windsurf
- Perfect for prototyping and testing

### **AWS Lambda**
```python
# lambda_function.py
from agents import WindsurfBedrockAgent

def lambda_handler(event, context):
    agent = WindsurfBedrockAgent()
    result = agent.analyze_code(event['code'], event['language'])
    return {'statusCode': 200, 'body': result}
```

### **AWS Fargate**
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY agents/ ./agents/
EXPOSE 8000

CMD ["python", "-m", "agents.api_server"]
```

### **EC2 Instance**
- Full control over environment
- Best for complex, long-running workflows

## 🔍 **Monitoring & Observability**

### **Built-in Logging**
```python
import logging

# Configure logging for agents
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Agents will automatically log activities
agent = WindsurfBedrockAgent()
```

### **OpenTelemetry Integration**
```python
from opentelemetry import trace
from agents import WindsurfStrandsAgent

# Strands Agents has built-in OTEL support
agent = WindsurfStrandsAgent(enable_telemetry=True)
```

### **AWS CloudWatch**
- Bedrock AgentCore automatically logs to CloudWatch
- Set up custom metrics and alarms

## 🧪 **Testing Your Integration**

```bash
# Run tests
python -m pytest tests/

# Test specific agent
python examples/basic_usage.py

# Test with your actual code
python -c "
from agents import WindsurfBedrockAgent
agent = WindsurfBedrockAgent()
print(agent.analyze_code('print(\"Hello World\")', 'python'))
"
```

## 🔄 **Continuous Integration**

Add to your `.github/workflows/test-agents.yml`:
```yaml
name: Test AI Agents

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    - name: Install dependencies
      run: |
        pip install -r requirements.txt
    - name: Run tests
      run: |
        python -m pytest tests/
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## 📚 **Next Steps**

1. **Create your agents repository** using the structure above
2. **Install and configure** both frameworks
3. **Test basic functionality** with the provided examples
4. **Integrate with your Windsurf projects** using your preferred method
5. **Customize agents** for your specific development workflows
6. **Set up monitoring** and observability
7. **Deploy to production** when ready

## 🆘 **Troubleshooting**

### **Common Issues**

**Bedrock Model Access Denied:**
- Ensure model access is enabled in AWS Console
- Check IAM permissions
- Verify region availability

**Strands Installation Issues:**
- Use Python 3.10+ 
- Install in clean virtual environment
- Check for conflicting dependencies

**Authentication Errors:**
- Verify AWS credentials configuration
- Check environment variables
- Ensure IAM permissions are correct

### **Getting Help**

- **Bedrock AgentCore**: [AWS Documentation](https://docs.aws.amazon.com/bedrock-agentcore/)
- **Strands Agents**: [GitHub Repository](https://github.com/strands-agents/sdk-python)
- **Windsurf**: [Official Documentation](https://docs.codeium.com/windsurf)

---

**🎉 You're now ready to supercharge your Windsurf development with AI agents!**
