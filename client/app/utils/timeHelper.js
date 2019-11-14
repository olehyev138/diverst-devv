export default function timeToString(time) {
  let hours = Math.floor((time % (3600 * 24)) / 3600);
  const noon = hours >= 12 ? 'PM' : 'AM';
  hours %= 12;
  if (hours === 0)
    hours = 12;

  const minutes = Math.floor((time % 3600) / 60);

  return `${hours}:${(`0${minutes}`).slice(-2)} ${noon}`;
}
