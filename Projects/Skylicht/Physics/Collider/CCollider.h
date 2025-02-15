/*
!@
MIT License

Copyright (c) 2024 Skylicht Technology CO., LTD

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This file is part of the "Skylicht Engine".
https://github.com/skylicht-lab/skylicht-engine
!#
*/

#pragma once

#include "Components/CComponentSystem.h"

#ifdef USE_BULLET_PHYSIC_ENGINE
#include <btBulletCollisionCommon.h>
#endif

namespace Skylicht
{
	namespace Physics
	{
		class CCollider : public CComponentSystem
		{
		public:
			enum EColliderType
			{
				Box,
				Sphere,
				Plane,
				Cylinder,
				Capsule,
				BvhMesh,
				ConvexMesh,
				Mesh,
				Unknown,
			};

		protected:
			EColliderType m_colliderType;

			core::vector3df m_offset;

			bool m_dynamicSupport;

#ifdef USE_BULLET_PHYSIC_ENGINE
			btCollisionShape* m_shape;
#endif

		public:
			CCollider();

			virtual ~CCollider();

			virtual void initComponent();

			EColliderType getColliderType()
			{
				return m_colliderType;
			}

#ifdef USE_BULLET_PHYSIC_ENGINE
			virtual btCollisionShape* initCollisionShape() = 0;

			virtual void dropCollisionShape();
#endif

			void initRigidbody();

			void clampSize(core::vector3df& size);

			inline bool isDynamicSupport()
			{
				return m_dynamicSupport;
			}
		};
	}
}