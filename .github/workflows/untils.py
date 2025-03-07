import type {RefObject} from 'react';
import {useCallback} from 'react';
import screenfull from 'screenfull';

interface Props<Element extends HTMLElement> {
  elementRef: RefObject<Element>;
}

interface Return {
  enter: (options?: FullscreenOptions) => void;
  exit: () => void;
  toggle: () => void;
}

export default function useFullscreen<Element extends HTMLElement>({
  elementRef,
}: Props<Element>): Return {
  const enter = useCallback(
    async (opts: FullscreenOptions = {navigationUI: 'auto'}) => {
      if (screenfull.isEnabled && elementRef.current) {
        await screenfull.request(elementRef.current, opts);
      }
    },
    [elementRef]
  );

  const exit = useCallback(async () => {
    if (screenfull.isEnabled) {
      await screenfull.exit();
    }
  }, []);

  const toggle = useCallback(
    () => (screenfull.isFullscreen ? exit() : enter()),
    [enter, exit]
  );

  return {
    enter,
    exit,
    toggle,
  };
}
