/*
 * Xdebug session switch — picks where the *next* request's debug session goes.
 *
 * Replaces the browser's Xdebug helper extension, so any browser can pick the destination, and
 * makes that destination visible instead of having to look the cookie up in devtools.
 *
 * Deliberately dependency-free and side-effect-free on the server: it only reads and writes
 * cookies. Nothing here may cause a request, because a request under the wrong destination opens a
 * DBGp session that blocks PHP until someone detaches. See Documentation/Xdebug-DBGp.md.
 *
 * Which cookie carries the destination differs, because PHPStorm is the default and must keep
 * XDEBUG_SESSION free for PHPStorm's own bookmarklet:
 *
 *   PHPSTORM  XDEBUG_TRIGGER=PHPSTORM   XDEBUG_SESSION deleted
 *   claude    XDEBUG_SESSION=claude     XDEBUG_TRIGGER deleted
 *
 * Both cookies act as a trigger for xdebug.start_with_request=trigger, and in both cases the
 * cookie *value* becomes the DBGp idekey the proxy routes on — xdebug.idekey is not a fallback,
 * which is why the default cannot simply be "no cookie at all": that starts no session.
 * Exactly one of the two is ever set, so the proxy can never see a contradictory pair.
 */
(function () {
    'use strict';

    // Must match the idekeys the two clients register with the proxy: xdebug_dbgp_proxy.ini for
    // PHPStorm, DBGP_IDEKEY in .mcp.json for Claude Code.
    var PHPSTORM = { idekey: 'PHPSTORM', cookie: 'XDEBUG_TRIGGER' };
    var CLAUDE = { idekey: 'claude', cookie: 'XDEBUG_SESSION' };

    // A stray copy of this widget on a real site would let any visitor steer a debug session, so
    // it only ever renders on a local development host.
    function isDevelopmentHost() {
        var host = window.location.hostname;
        return /(^|\.)ddev\.site$/.test(host)
            || /(^|\.)localhost$/.test(host)
            || host === '127.0.0.1'
            || host === '[::1]';
    }

    function hasCookie(name) {
        return document.cookie.match('(^|;)\\s*' + name + '\\s*=') !== null;
    }

    // A cookie can only be deleted through the exact path it was set on, and copies set by the
    // Xdebug helper browser extension or by an earlier visit to /typo3/ may sit on a narrower
    // path than ours. Such a copy is invisible to a single path=/ delete yet still sent to PHP,
    // so sweep the whole path hierarchy. Max-Age=0 plus an expired date because some browsers
    // honour only one of the two.
    function deleteCookie(name) {
        var expire = '=; Max-Age=0; expires=Thu, 01 Jan 1970 00:00:00 GMT';
        var paths = ['/'];
        var walked = '';
        window.location.pathname.split('/').forEach(function (segment) {
            if (segment !== '') {
                walked += '/' + segment;
                paths.push(walked, walked + '/');
            }
        });
        document.cookie = name + expire;
        paths.forEach(function (path) {
            document.cookie = name + expire + '; path=' + path;
        });
    }

    /**
     * Mirrors Xdebug's own precedence, which is XDEBUG_TRIGGER over XDEBUG_SESSION — verified
     * against the proxy by sending both cookies at once. Getting this backwards makes the pill
     * name a destination other than the one PHP will dial, which reads as a dead breakpoint.
     */
    function selected() {
        if (hasCookie(PHPSTORM.cookie)) {
            return PHPSTORM;
        }
        return hasCookie(CLAUDE.cookie) ? CLAUDE : PHPSTORM;
    }

    function select(target) {
        var other = target === CLAUDE ? PHPSTORM : CLAUDE;
        deleteCookie(other.cookie);
        document.cookie = target.cookie + '=' + target.idekey + '; path=/; SameSite=Lax';
    }

    var STYLE = [
        ':host { all: initial; }',
        '.pill {',
        // Centered rather than in a corner: the corners hold the logo, the burger, the admin panel
        // and the cookie banner, and which of those is where depends on the breakpoint. The middle
        // of the top bar is free at every width, in the frontend and in the backend alike.
        '  position: fixed; top: 8px; left: 50%; transform: translateX(-50%);',
        '  z-index: 2147483000;',
        '  display: flex; align-items: center; gap: 6px;',
        '  padding: 4px 10px; border: 0; border-radius: 999px; cursor: pointer;',
        '  font: 12px/1.4 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;',
        '  background: rgba(20, 22, 26, 0.82); color: #e6e6e6;',
        '  backdrop-filter: blur(3px);',
        '}',
        '.pill:hover { background: rgba(20, 22, 26, 0.95); }',
        '.dot { width: 7px; height: 7px; border-radius: 50%; background: #38bdf8; }',
        '.pill[data-target="claude"] .dot { background: #f59e0b; }'
    ].join('\n');

    function render() {
        var host = document.createElement('div');
        host.id = 'xdebug-session-switch';
        // Shadow DOM in both directions: the site's CSS cannot deform the widget, and the
        // widget's CSS cannot leak into the page it is meant to observe.
        var root = host.attachShadow({ mode: 'open' });

        var style = document.createElement('style');
        style.textContent = STYLE;
        root.appendChild(style);

        var pill = document.createElement('button');
        pill.className = 'pill';
        pill.type = 'button';
        var dot = document.createElement('span');
        dot.className = 'dot';
        var label = document.createElement('span');
        pill.appendChild(dot);
        pill.appendChild(label);
        root.appendChild(pill);

        function update() {
            var target = selected();
            var other = target === CLAUDE ? PHPSTORM : CLAUDE;
            pill.dataset.target = target === CLAUDE ? 'claude' : 'phpstorm';
            label.textContent = 'xdebug → ' + target.idekey;
            pill.title = 'The next request debugs in ' + target.idekey + '.'
                + ' Click to switch to ' + other.idekey
                + '. Takes effect immediately, no reload needed.';
        }

        pill.addEventListener('click', function () {
            select(selected() === CLAUDE ? PHPSTORM : CLAUDE);
            update();
        });

        // The pill must never claim a destination that is not armed, and with a trigger-gated
        // Xdebug "no cookie" arms nothing. So normalise to the default on first sight.
        select(selected());
        update();
        document.body.appendChild(host);
    }

    if (!isDevelopmentHost() || document.getElementById('xdebug-session-switch')) {
        return;
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', render);
    } else {
        render();
    }
})();
