from mcp.server.fastmcp import FastMCP
import httpx
from bs4 import BeautifulSoup
import json

mcp = FastMCP("ifdb-tool")

BASE_URL = "https://ifdb.org"


def _fetch_games(searchfor: str) -> list[dict]:
    response = httpx.get(
        f"{BASE_URL}/search",
        params={"json": "1", "game": "1", "searchfor": searchfor},
        follow_redirects=True,
    )
    response.raise_for_status()
    return response.json()["games"]


def get_gblorb_links(game_id: str) -> list[str]:
    """Helper: fetch the game page and return all .gblorb download URLs."""
    page = httpx.get(f"{BASE_URL}/viewgame?id={game_id}", follow_redirects=True)
    soup = BeautifulSoup(page.text, "html.parser")
    return [
        a["href"] for a in soup.find_all("a", href=True)
        if a["href"].endswith(".gblorb")
    ]


PLAYABLE_EXTENSIONS = (".z5", ".z8", ".zblorb", ".gblorb", ".ulx")

def get_download_links(game_id: str) -> list[str]:
    """Helper: fetch the game page and return all playable download URLs (deduplicated)."""
    page = httpx.get(f"{BASE_URL}/viewgame?id={game_id}", follow_redirects=True)
    soup = BeautifulSoup(page.text, "html.parser")
    seen = set()
    links = []
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if href.endswith(PLAYABLE_EXTENSIONS) and "iplayif.com" not in href and href not in seen:
            seen.add(href)
            links.append(href)
    return links


@mcp.tool()
def get_top_rated_game() -> str:
    """Get the top-rated game on IFDB, including its gblorb download links."""

    games = _fetch_games("#ratings:1-")
    game = max(games, key=lambda g: g["starSort"])
    return json.dumps({
        "title": game["title"],
        "author": game["author"],
        "average_rating": game["averageRating"],
        "num_ratings": game["numRatings"],
        "gblorb_urls": get_gblorb_links(game["tuid"]),
    })


@mcp.tool()
def get_most_rated_game() -> str:
    """Get the most-rated game on IFDB (highest number of ratings), including its gblorb download links."""

    games = _fetch_games("#ratings:1-")
    game = max(games, key=lambda g: g["numRatings"])
    return json.dumps({
        "title": game["title"],
        "author": game["author"],
        "average_rating": game["averageRating"],
        "num_ratings": game["numRatings"],
        "gblorb_urls": get_gblorb_links(game["tuid"]),
    })


@mcp.tool()
def get_game_by_title(title: str) -> str:
    """Search IFDB by title and return the best-matching game with its download links."""

    games = _fetch_games(title)
    if not games:
        return json.dumps({"error": f"No game found for title: {title}"})
    game = games[0]
    return json.dumps({
        "title": game["title"],
        "author": game["author"],
        "average_rating": game["averageRating"],
        "num_ratings": game["numRatings"],
        "download_urls": get_download_links(game["tuid"]),
    })


if __name__ == "__main__":
    mcp.run(transport="stdio")
