<script lang="ts">
    export let match: any
    export let playerSymbol: string
    export let live

    const hostSymbol = "X"
    const isHost = playerSymbol == hostSymbol
    
    const inviteURL = (typeof window !== "undefined") ? window.location.href + "?g" : "Loading..."

    let heading = `${getPlayerTurn(match)}'s turn`
    $: if (match.game_status == "ongoing") heading = `${getPlayerTurn(match)}'s turn`
    function getPlayerTurn(match) {
        if (match.turn == hostSymbol) return match.host_player
        else return match.guest_player
    }

    let nickname: string

    $: if (match.game_status != "waiting" && live) statusNotify(match.game_status)

    function statusNotify(status) {
        switch(status) {
            case "X_won": {
                heading = "X won!"
                const type = isHost ? "info" : "error"
                // live.pushEvent("put_flash", {type: type, message: heading})
                break
            }
            case "O_won": {
                heading = "O won!"
                const type = !isHost ? "info" : "error"
                // live.pushEvent("put_flash", {type: type, message: heading})
                break
            }
            case "draw": {
                heading = "Draw!"
                // live.pushEvent("put_flash", {type: "info", message: heading})
                break
            }
        }
    }

    function makeMove(i: number) {
        live.pushEvent("make_move", {id: match.id, index: i, symbol: playerSymbol})
    }

    function copyToClipboard() {
        navigator.clipboard.writeText(inviteURL)
        live.pushEvent("put_flash", {type: "info", message: "Copied to clipboard!"})
    }

    function shareInvite() {
        navigator.share({
            title: "tic tac toe thing",
            text: "play tictactoe with me!",
            url: inviteURL
        })
    }

    function nicknameInput() {
        live.pushEvent("guest_nickname_input", {id: match.id, nickname})
    }
</script>

<!-- <div class="text-xs">{JSON.stringify(match)} player symbol: {playerSymbol}</div> -->

<h1 class="text-4xl text-center mb-2 text-seagull-800">{heading}</h1>

<div class="w-full h-full grid grid-cols-3 grid-rows-3 relative after:absolute after:w-full after:h-full after:bg-transparent after:border-4 after:border-seagull-200 after:pointer-events-none">
    {#each match.state as cell, i}
        <button
            disabled={(cell == "X" || cell == "O") || (match.turn != playerSymbol) || (match.game_status != "ongoing")}
            class="h-full w-full text-[600%] select-none flex items-center justify-center aspect-square border-4 rounded-lg border-seagull-900 text-seagull-900"
            on:click={() => makeMove(i)}
        >
            <span class="-my-16">{cell}</span>
        </button>
    {/each}
</div>

{#if match.game_status == "waiting" && isHost}
<div class="flex items-center justify-center fixed left-0 bottom-0 w-full h-full bg-gray-800/20 text-seagull-800">
    <div class="bg-white rounded-2xl sm:min-w-[500px] mx-2 text-center py-2 shadow-lg">
      <div class="flex flex-col items-start p-4">
        <div class="flex flex-col items-center gap-4 mx-auto">
          <div class="text-seagull-900 font-medium text-xl sm:text-2xl">Waiting for another player to join</div>
          <svg class="animate-spin ml-1 mr-3 h-10 w-10 text-seagull-700" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>

        <label class="flex flex-col mx-auto my-4 font-semibold w-5/6">
            Invite link
            <input type="text" value={inviteURL} class="font-normal" readonly>
        </label>

        <div class="mx-auto">
          <button on:click={shareInvite} class="mx-1 bg-seagull-600 hover:bg-seagull-700 text-white font-bold py-2 px-4 rounded">
            Share
          </button>
          <button on:click={copyToClipboard} class="mx-1 bg-transparent hover:bg-gray-200 text-seagull-700 font-semibold py-2 px-4 border border-seagull-600 rounded">
            Copy to clipboard
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}

{#if match.game_status == "waiting" && !isHost}
<div class="flex items-center justify-center fixed left-0 bottom-0 w-full h-full bg-gray-800/20 text-seagull-800">
    <div class="bg-white rounded-2xl w-full sm:min-w-[500px] sm:w-auto mx-2 py-2 shadow-lg">
      <div class="flex flex-col items-start p-4">
        <div class="flex flex-col items-center gap-4 mx-auto">
          <div class="text-seagull-900 font-medium text-2xl">Hello!</div>
        </div>

        <form class="w-full" on:submit|preventDefault={nicknameInput}>
            <label class="flex flex-col mx-auto my-4 font-semibold w-5/6">
                Enter a nickname to start
                <input type="text" placeholder="Nickname" minlength="3"  maxlength="25" class="font-normal invalid:ring-red-500" bind:value={nickname}>
            </label>

            <div class="w-full flex justify-center">
                <button on:click={nicknameInput} class="bg-seagull-600 hover:bg-seagull-700 text-white font-bold py-2 px-4 rounded">
                    Done
                </button>
            </div>
        </form>

      </div>
    </div>
  </div>
{/if}