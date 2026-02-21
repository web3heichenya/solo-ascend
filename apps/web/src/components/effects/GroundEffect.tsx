'use client';

import { Canvas } from '@react-three/fiber';
import { useRef, useMemo } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';

const GroundParticles = () => {
  const groundRef = useRef<THREE.Points>(null!);

  const groundGeometry = useMemo(() => {
    const positions = new Float32Array(2000 * 3);

    for (let i = 0; i < 2000; i++) {
      const x = (Math.random() - 0.5) * 200;
      const z = (Math.random() - 0.5) * 100;

      const centerDistance = Math.sqrt((x * x) / 400 + (z * z) / 100);
      const waveHeight = Math.sin(centerDistance * 2) * 0.5 + Math.cos(centerDistance * 3) * 0.3;
      const y = -2 + waveHeight + Math.random() * 0.2;

      positions[i * 3] = x;
      positions[i * 3 + 1] = y;
      positions[i * 3 + 2] = z;
    }

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    return geometry;
  }, []);

  const groundMaterial = useMemo(
    () =>
      new THREE.PointsMaterial({
        color: 0x00ff88,
        size: 0.4,
        transparent: true,
        opacity: 0.6,
      }),
    []
  );

  useFrame(({ clock }) => {
    if (groundRef.current) {
      const time = clock.getElapsedTime();

      const positionAttribute = groundRef.current.geometry.getAttribute(
        'position'
      ) as THREE.BufferAttribute;
      const positions = positionAttribute.array as Float32Array;

      for (let i = 0; i < 2000; i++) {
        const x = positions[i * 3];
        const z = positions[i * 3 + 2];

        const centerDistance = Math.sqrt((x * x) / 400 + (z * z) / 100);
        const waveHeight =
          Math.sin(centerDistance * 2 + time * 0.5) * 0.5 +
          Math.cos(centerDistance * 3 + time * 0.3) * 0.3;
        positions[i * 3 + 1] = -2 + waveHeight + Math.sin(time * 2 + x * 0.01) * 0.1;
      }

      positionAttribute.needsUpdate = true;
    }
  });

  return <points ref={groundRef} geometry={groundGeometry} material={groundMaterial} />;
};

const Scene = () => {
  return (
    <>
      <GroundParticles />
    </>
  );
};

export default function GroundEffect() {
  return (
    <div className="fixed right-0 bottom-0 left-0 -z-10 h-56">
      <Canvas
        camera={{
          position: [0, 10, 20],
          fov: 60,
          near: 0.1,
          far: 1000,
        }}
        style={{ background: 'transparent' }}
      >
        <Scene />
      </Canvas>
    </div>
  );
}
