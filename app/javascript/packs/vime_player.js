// Default theme. ~960B
import '@vime/core/themes/default.css';

// Optional light theme (extends default). ~400B
import '@vime/core/themes/light.css';

import { VmPlayer, VmVideo, VmFile, defineCustomElements } from '@vime/core';

// 1. Manually define them to be as efficient as possible.
customElements.define('vm-player', VmPlayer);
customElements.define('vm-video', VmVideo);
customElements.define('vm-file', VmFile);

// 2. Can't be bothered? Load them all in, may bloat your final bundle size a little.
defineCustomElements();