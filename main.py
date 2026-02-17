from fastmcp import FastMCP
from starlette.responses import JSONResponse

mcp = FastMCP()

@mcp.tool
def add(x: int, y: int) -> int:
    return x + y

@mcp.tool
def multiply(x: int, y: int) -> int:
    return x * y

@mcp.tool
def greet(name: str) -> str:
    return f"Hello, {name}!"

if __name__ == "__main__":
    mcp.run(transport="streamable-http", host="0.0.0.0", port=8000)