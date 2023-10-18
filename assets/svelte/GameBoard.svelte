<script lang="ts">
    import { onMount, tick } from "svelte"

    interface Message {
        sender: string
        content: string
    }

    export let match: any
    export let playerSymbol: string | null
    export let role: string
    export let initialMessages: any[]

    export let live

    let messages: Message[] = []
    messages = initialMessages.map((message) => {
        return { sender: message.user, content: message.content }
    })

    let chatOpen = false

    $: console.log("Match state: ", match)
    $: scrollToBottom(messages)

    async function scrollToBottom(_value: any) {
        if (typeof window == "undefined") return
        let chatbox = document.getElementById("chatbox")
        await tick()
        if (chatbox) chatbox.scrollTop = chatbox.scrollHeight
    }

    const hostSymbol = "X"

    onMount(() => {
        scrollToBottom(null)

        if (live) {
            live.handleEvent("received_message", (data) => {
                const message: Message = {
                    content: data.message.content,
                    sender: data.message.user,
                }
                messages = [...messages, message]
            })
        }
    })

    const inviteURL = match.short_link_id
        ? getInviteURL(match.short_link_id.code)
        : "null"

    function getInviteURL(code) {
        if (typeof window == "undefined") return "Loading..."
        const parsedURL = new URL(window.location.href)
        return `${parsedURL.protocol}//${parsedURL.host}/m/${code}`
    }

    let heading = `${getPlayerTurn(match)}'s turn`
    $: if (match.game_status == "ongoing")
        heading = `${getPlayerTurn(match)}'s turn`
    function getPlayerTurn(match) {
        if (match.turn == hostSymbol) return match.host_player
        else return match.guest_player
    }

    let nickname: string

    $: if (match.game_status != "waiting_join" && live)
        statusNotify(match.game_status)

    function statusNotify(status) {
        switch (status) {
            case "X_won": {
                heading = `${match.host_player} won!`
                break
            }
            case "O_won": {
                heading = `${match.guest_player} won!`
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
        live.pushEvent("make_move", {
            id: match.id,
            index: i,
            symbol: playerSymbol,
        })
    }

    function copyToClipboard() {
        navigator.clipboard.writeText(inviteURL)
        live.pushEvent("put_flash", {
            type: "info",
            message: "Copied to clipboard!",
        })
    }

    function shareInvite() {
        navigator.share({
            title: "tic tac toe thing",
            text: "play tictactoe with me!",
            url: inviteURL,
        })
    }

    function nicknameInput() {
        live.pushEvent("guest_nickname_input", { id: match.id, nickname })
    }

    function sendMessage(e) {
        if (role == "spectator") return
        const input = e.srcElement[0]
        const user = role == "host" ? match.host_player : match.guest_player
        live.pushEvent("send_message", { content: input.value })
        input.value = ""
    }
</script>

<div class={"transition duration-300 " + (chatOpen ? "sm:-translate-x-[20vw]" : "")}>
    <h1 class="text-4xl text-center mb-2 text-seagull-800">{heading}</h1>
    
    <div
        class="w-full h-full grid grid-cols-3 grid-rows-3 relative after:absolute after:w-full after:h-full after:bg-transparent after:border-4 after:border-seagull-200 after:pointer-events-none after:rounded-3xl"
    >
        {#each match.state as cell, i}
            <button
                disabled={cell == "X" ||
                    cell == "O" ||
                    match.turn != playerSymbol ||
                    match.game_status != "ongoing" ||
                    role == "spectator"}
                class="h-full w-full text-[600%] select-none flex items-center justify-center aspect-square border-4 rounded-lg border-seagull-900 text-seagull-900"
                on:click={() => makeMove(i)}
            >
                <span class="-my-16">{cell}</span>
            </button>
        {/each}
    </div>
</div>

<div
    class={"sm:absolute sm:w-2/6 sm:h-[calc(100%-2rem)] mt-8 sm:mt-0 top-0 right-0 flex items-center transition duration-300 " + (chatOpen ? "" : "sm:translate-x-[98%]")}
>
    <button
        class="text-6xl absolute -translate-x-10 text-seagull-800 hidden sm:block bg-seagull-100 px-2 rounded-l-xl"
        on:click={() => (chatOpen = !chatOpen)}><div class={"transition duration-300 " + (chatOpen ? "rotate-180 translate-y-1" : "")}>&lt;</div></button
    >
    <section class="bg-seagull-100 sm:w-full rounded-xl h-64 sm:h-4/6 p-4 pt-2">
        <div
            class="overflow-y-scroll h-[calc(100%-3rem)] px-2 text-seagull-800"
            id="chatbox"
        >
            {#each messages as message}
                <div class="my-4 w-full overflow-x-hidden flex gap-4">
                    <span class="font-medium text-seagull-900 whitespace-nowrap"
                        >{message.sender}:</span
                    >
                    <span lang="en" class="break-all">{message.content}</span>
                </div>
            {/each}
        </div>
        <form on:submit|preventDefault={sendMessage}>
            <input
                class="w-full"
                type="text"
                minlength="1"
                maxlength="200"
                required
            />
        </form>
    </section>
</div>

{#if match.game_status == "waiting_join" && role == "host"}
    <div
        class="flex items-center justify-center fixed left-0 bottom-0 w-full h-full bg-gray-800/20 text-seagull-800"
    >
        <div
            class="bg-white rounded-2xl sm:min-w-[500px] mx-2 text-center py-2 shadow-lg"
        >
            <div class="flex flex-col items-start p-4">
                <div class="flex flex-col items-center gap-4 mx-auto">
                    <div
                        class="text-seagull-900 font-medium text-xl sm:text-2xl"
                    >
                        Waiting for another player to join
                    </div>
                    <svg
                        class="animate-spin ml-1 mr-3 h-10 w-10 text-seagull-700"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                    >
                        <circle
                            class="opacity-25"
                            cx="12"
                            cy="12"
                            r="10"
                            stroke="currentColor"
                            stroke-width="4"
                        />
                        <path
                            class="opacity-75"
                            fill="currentColor"
                            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                        />
                    </svg>
                </div>

                <label class="flex flex-col mx-auto my-4 font-semibold w-5/6">
                    Invite link
                    <input
                        type="text"
                        value={inviteURL}
                        class="font-normal"
                        readonly
                    />
                </label>

                <div class="mx-auto">
                    <button
                        on:click={shareInvite}
                        class="mx-1 bg-seagull-600 hover:bg-seagull-700 text-white font-bold py-2 px-4 rounded"
                    >
                        Share
                    </button>
                    <button
                        on:click={copyToClipboard}
                        class="mx-1 bg-transparent hover:bg-gray-200 text-seagull-700 font-semibold py-2 px-4 border border-seagull-600 rounded"
                    >
                        Copy to clipboard
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}

{#if match.game_status == "waiting_join" && role == "guest"}
    <div
        class="flex items-center justify-center fixed left-0 bottom-0 w-full h-full bg-gray-800/20 text-seagull-800"
    >
        <div
            class="bg-white rounded-2xl w-full sm:min-w-[500px] sm:w-auto mx-2 py-2 shadow-lg"
        >
            <div class="flex flex-col items-start p-4">
                <div class="flex flex-col items-center gap-4 mx-auto">
                    <div class="text-seagull-900 font-medium text-2xl">
                        Hello!
                    </div>
                </div>

                <form class="w-full" on:submit|preventDefault={nicknameInput}>
                    <label
                        class="flex flex-col mx-auto my-4 font-semibold w-5/6"
                    >
                        Enter a nickname to start
                        <input
                            type="text"
                            placeholder="Nickname"
                            minlength="3"
                            maxlength="25"
                            required
                            class="font-normal invalid:ring-red-500"
                            bind:value={nickname}
                        />
                    </label>

                    <div class="w-full flex justify-center">
                        <button
                            class="bg-seagull-600 hover:bg-seagull-700 text-white font-bold py-2 px-4 rounded"
                        >
                            Done
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
{/if}
