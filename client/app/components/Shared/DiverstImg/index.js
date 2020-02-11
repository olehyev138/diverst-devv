import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export function DiverstImg(props) {
  const { classes, data, maxWidth, maxHeight, minWidth, minHeight, width, height, alt, styles, imgProps, naturalSrc, ...rest } = props;

  return (
    <React.Fragment>
      {data && (
        <img
          src={naturalSrc ? data : `data:image/jpeg;base64,${data}`}
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
      )}
    </React.Fragment>
  );
}

DiverstImg.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.string.isRequired,
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
};

export default compose(
  memo,
)(DiverstImg);
