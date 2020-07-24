import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export function DiverstImg(props) {
  const { className, data, contentType, maxWidth, maxHeight, minWidth, minHeight,
    width, height, alt, styles, imgProps, naturalSrc, emptyVariant, ...rest } = props;

  function image() {
    if (data)
      return (
        <img
          className={className}
          src={naturalSrc ? data : `data:${contentType};base64,${data}`}
          alt={alt}
          style={{
            maxWidth,
            maxHeight,
            minWidth,
            minHeight,
            width,
            height,
            ...styles,
          }}
        />
      );
    if (emptyVariant === 'placeholder' || emptyVariant === 'reserve')
      return (
        <svg width={maxWidth} height={maxHeight} viewBox='0 0 100 100'>
          {emptyVariant === 'placeholder' && <rect width='100' height='100' rx='10' ry='10' fill='#EEE' />}
        </svg>
      );
    return <React.Fragment />;
  }

  return (
    <React.Fragment>
      {image()}
    </React.Fragment>
  );
}

DiverstImg.defaultProps = {
  contentType: 'image/jpeg'
};

DiverstImg.propTypes = {
  className: PropTypes.string,
  data: PropTypes.string,
  contentType: PropTypes.string,
  maxWidth: PropTypes.string,
  maxHeight: PropTypes.string,
  minWidth: PropTypes.string,
  minHeight: PropTypes.string,
  width: PropTypes.string,
  height: PropTypes.string,
  naturalSrc: PropTypes.bool,
  alt: PropTypes.string,
  styles: PropTypes.object,
  imgProps: PropTypes.object,
  emptyVariant: PropTypes.oneOf(['placeholder', 'reserve', 'ignore']),
};

DiverstImg.defaultProps = {
  emptyVariant: 'ignore'
};

export default compose(
  memo,
)(DiverstImg);
