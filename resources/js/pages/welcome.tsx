import { type SharedData } from '@/types';
import { usePage } from '@inertiajs/react';

export default function Welcome() {
    const { auth } = usePage<SharedData>().props;

    return (
        <>
        <h1 className='text-3xl font-bold underline bg-red-500'>Welcome</h1>
        </>
    );
}
