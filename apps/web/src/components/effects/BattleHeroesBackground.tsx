'use client';

import { Canvas } from '@react-three/fiber';
import { useRef, useMemo } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';
import { useMediaQuery } from 'usehooks-ts';

const StarField = () => {
  const starsRef = useRef<THREE.Points>(null!);

  const starsGeometry = useMemo(() => {
    const positions = new Float32Array(1000 * 3);
    for (let i = 0; i < 1000; i++) {
      positions[i * 3] = (Math.random() - 0.5) * 100;
      positions[i * 3 + 1] = Math.random() * 50 + 10;
      positions[i * 3 + 2] = (Math.random() - 0.5) * 100;
    }
    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    return geometry;
  }, []);

  const starsMaterial = useMemo(
    () =>
      new THREE.PointsMaterial({
        color: 0x00ffff,
        size: 0.3,
        transparent: true,
        opacity: 0.4,
      }),
    []
  );

  useFrame(() => {
    if (starsRef.current) {
      starsRef.current.rotation.y += 0.0005;
    }
  });

  return <points ref={starsRef} geometry={starsGeometry} material={starsMaterial} />;
};

const Hero = ({
  position,
  color,
  animationOffset,
}: {
  position: [number, number, number];
  color: number;
  animationOffset: number;
}) => {
  const heroRef = useRef<THREE.Group>(null!);
  const particlesRef = useRef<THREE.Points>(null!);

  const heroGeometry = useMemo(() => {
    const positions = new Float32Array(150 * 3);

    for (let i = 0; i < 50; i++) {
      const angle = (i / 50) * Math.PI * 2;
      const radius = 1.5;
      positions[i * 3] = Math.cos(angle) * radius;
      positions[i * 3 + 1] = Math.sin(angle) * radius * 0.6;
      positions[i * 3 + 2] = 0;
    }

    for (let i = 50; i < 100; i++) {
      const t = (i - 50) / 50;
      positions[i * 3] = (Math.random() - 0.5) * 3;
      positions[i * 3 + 1] = t * 6 - 3;
      positions[i * 3 + 2] = (Math.random() - 0.5) * 0.5;
    }

    for (let i = 100; i < 150; i++) {
      const angle = ((i - 100) / 50) * Math.PI * 4;
      positions[i * 3] = Math.cos(angle) * 2.5;
      positions[i * 3 + 1] = -3 + Math.sin(angle * 2) * 0.5;
      positions[i * 3 + 2] = 0;
    }

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    return geometry;
  }, []);

  const heroMaterial = useMemo(
    () =>
      new THREE.PointsMaterial({
        color,
        size: 0.25,
        transparent: true,
        opacity: 0.6,
      }),
    [color]
  );

  useFrame(({ clock }) => {
    if (heroRef.current && particlesRef.current) {
      const time = clock.getElapsedTime() + animationOffset;

      heroRef.current.position.x = position[0] + Math.sin(time * 0.5) * 0.3;
      heroRef.current.position.y = position[1] + Math.sin(time * 1.2) * 0.2;
      heroRef.current.rotation.y = Math.sin(time * 0.8) * 0.3;

      const positionAttribute = particlesRef.current.geometry.getAttribute(
        'position'
      ) as THREE.BufferAttribute;
      const positions = positionAttribute.array as Float32Array;

      for (let i = 100; i < 150; i++) {
        const angle = ((i - 100) / 50) * Math.PI * 4 + time * 2;
        positions[i * 3] = Math.cos(angle) * 2.5;
        positions[i * 3 + 1] = -3 + Math.sin(angle * 2 + time) * 0.8;
      }

      positionAttribute.needsUpdate = true;
    }
  });

  return (
    <group ref={heroRef} position={position}>
      <points ref={particlesRef} geometry={heroGeometry} material={heroMaterial} />
    </group>
  );
};

const Ground = () => {
  const groundRef = useRef<THREE.Points>(null!);

  const groundGeometry = useMemo(() => {
    const positions = new Float32Array(800 * 3);
    for (let i = 0; i < 800; i++) {
      const x = (Math.random() - 0.5) * 80;
      const z = (Math.random() - 0.5) * 80;
      const y = -8 + Math.sqrt(Math.max(0, 100 - (x * x) / 20 - (z * z) / 20)) * 2;
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
        size: 0.3,
        transparent: true,
        opacity: 0.3,
      }),
    []
  );

  useFrame(({ clock }) => {
    if (groundRef.current) {
      groundRef.current.rotation.y = clock.getElapsedTime() * 0.1;
    }
  });

  return <points ref={groundRef} geometry={groundGeometry} material={groundMaterial} />;
};

const Scene = ({ isMobile }: { isMobile: boolean }) => {
  const heroDistance = isMobile ? 5 : 8;

  return (
    <>
      <StarField />
      <Hero position={[-heroDistance, -2, 0]} color={0x00aaff} animationOffset={0} />
      <Hero position={[heroDistance, -2, 0]} color={0xff4400} animationOffset={Math.PI} />
      <Ground />
    </>
  );
};

export default function BattleHeroesBackground() {
  const isMobile = useMediaQuery('(max-width: 767px)');

  return (
    <div className="fixed inset-0 -z-10">
      <Canvas
        camera={{
          position: [0, 5, 25],
          fov: 60,
          near: 0.1,
          far: 1000,
        }}
        style={{ background: 'linear-gradient(to bottom, #000011, #001122)' }}
      >
        <Scene isMobile={isMobile} />
      </Canvas>
    </div>
  );
}
